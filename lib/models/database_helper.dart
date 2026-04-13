import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import 'transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pocketpal.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        currency TEXT NOT NULL
      )
    ''');
  }

  // เพิ่ม transaction
  Future<int> insertTransaction(Transaction t) async {
    final db = await database;
    return await db.insert('transactions', {
      'id': t.id,
      'type': t.type,
      'category': t.category,
      'amount': t.amount,
      'date': t.date.toIso8601String(),
      'currency': t.currency,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ดึง transaction ทั้งหมด
  Future<List<Transaction>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return maps
        .map(
          (map) => Transaction(
            id: map['id'],
            type: map['type'],
            category: map['category'],
            amount: map['amount'],
            date: DateTime.parse(map['date']),
            currency: map['currency'],
          ),
        )
        .toList();
  }

  // ลบ transaction
  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // ลบทั้งหมด
  Future<int> deleteAllTransactions() async {
    final db = await database;
    return await db.delete('transactions');
  }

  // ดึงเฉพาะ income
  Future<List<Transaction>> getIncomeTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'type = ?',
      whereArgs: ['income'],
      orderBy: 'date DESC',
    );

    return maps
        .map(
          (map) => Transaction(
            id: map['id'],
            type: map['type'],
            category: map['category'],
            amount: map['amount'],
            date: DateTime.parse(map['date']),
            currency: map['currency'],
          ),
        )
        .toList();
  }

  // ดึงเฉพาะ expense
  Future<List<Transaction>> getExpenseTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'type = ?',
      whereArgs: ['expense'],
      orderBy: 'date DESC',
    );

    return maps
        .map(
          (map) => Transaction(
            id: map['id'],
            type: map['type'],
            category: map['category'],
            amount: map['amount'],
            date: DateTime.parse(map['date']),
            currency: map['currency'],
          ),
        )
        .toList();
  }

  // คำนวณยอดรวม income
  Future<double> getTotalIncome() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['income'],
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  // คำนวณยอดรวม expense
  Future<double> getTotalExpense() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['expense'],
    );
    return (result.first['total'] as double?) ?? 0.0;
  }
}
