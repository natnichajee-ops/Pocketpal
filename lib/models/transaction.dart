class Transaction {
  final String id;
  final String type; // 'income' or 'expense'
  final String category;
  final double amount;
  final DateTime date;
  final String currency;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.currency,
  });
}

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final List<Transaction> transactions = [
    Transaction(
      id: '1',
      type: 'income',
      category: 'FOOD',
      amount: 10000,
      date: DateTime(2005, 8, 11),
      currency: 'THB',
    ),
    Transaction(
      id: '2',
      type: 'expense',
      category: 'FOOD',
      amount: 100,
      date: DateTime(2005, 8, 11),
      currency: 'THB',
    ),
  ];

  void addTransaction(Transaction t) {
    transactions.add(t);
  }

  double get totalIncome => transactions
      .where((t) => t.type == 'income')
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == 'expense')
      .fold(0, (sum, t) => sum + t.amount);
}