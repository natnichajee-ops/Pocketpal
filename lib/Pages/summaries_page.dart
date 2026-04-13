import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/transaction.dart';
import '../models/database_helper.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'profile_page.dart';

class SummariesPage extends StatefulWidget {
  const SummariesPage({super.key});

  @override
  State<SummariesPage> createState() => _SummariesPageState();
}

class _SummariesPageState extends State<SummariesPage> {
  int _currentIndex = 1;
  final DatabaseHelper _db = DatabaseHelper();

  List<Transaction> _transactions = [];
  double _totalIncome = 0;
  double _totalExpense = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final transactions = await _db.getAllTransactions();
    final totalIncome = await _db.getTotalIncome();
    final totalExpense = await _db.getTotalExpense();
    setState(() {
      _transactions = transactions;
      _totalIncome = totalIncome;
      _totalExpense = totalExpense;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalIncome + _totalExpense;
    final incomeRatio = total > 0 ? _totalIncome / total : 0.96;
    final expenseRatio = total > 0 ? _totalExpense / total : 0.04;

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Summaries',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('TOTAL',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(8)),
                      child: Text(_getMonthName(DateTime.now().month),
                          style: const TextStyle(fontSize: 14, color: AppColors.mediumGray)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(200, 200),
                            painter: _DonutPainter(incomeRatio: incomeRatio.toDouble(), expenseRatio: expenseRatio.toDouble()),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${(incomeRatio * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.incomeGreen, shape: BoxShape.circle)),
                                const SizedBox(width: 4),
                                const Text('INCOME', style: TextStyle(fontSize: 9, color: AppColors.mediumGray)),
                              ]),
                              const SizedBox(height: 2),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.expenseRed, shape: BoxShape.circle)),
                                const SizedBox(width: 4),
                                const Text('EXPENSE', style: TextStyle(fontSize: 9, color: AppColors.mediumGray)),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SummaryCard(label: 'TOTAL INCOME', amount: _totalIncome, color: AppColors.incomeGreen),
                    const SizedBox(height: 12),
                    _SummaryCard(label: 'TOTAL EXPENSE', amount: _totalExpense, color: AppColors.expenseRed),
                    const SizedBox(height: 20),
                    if (_transactions.isNotEmpty) ...[
                      const Text('Recent Transactions',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                      const SizedBox(height: 12),
                      ..._transactions.take(10).map((t) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    color: t.type == 'income' ? AppColors.incomeGreen.withValues(alpha: 0.2) : AppColors.expenseRed.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Icon(t.type == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: t.type == 'income' ? AppColors.incomeGreen : AppColors.expenseRed, size: 16)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(t.category, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                                    Text('${t.date.day}/${t.date.month}/${t.date.year} · ${t.currency}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.mediumGray)),
                                  ]),
                                ),
                                Text(
                                  '${t.type == 'income' ? '+' : '-'}${t.amount.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                                      color: t.type == 'income' ? AppColors.incomeGreen : AppColors.expenseRed),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async { await _db.deleteTransaction(t.id); _loadData(); },
                                  child: const Icon(Icons.delete_outline, color: AppColors.mediumGray, size: 18),
                                ),
                              ],
                            ),
                          )),
                    ] else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('ยังไม่มีรายการค่ะ\nลองเพิ่ม income หรือ expense ดูนะคะ',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.mediumGray, fontSize: 14)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) Navigator.pop(context);
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month];
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const _SummaryCard({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(amount.toStringAsFixed(2), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double incomeRatio;
  final double expenseRatio;
  _DonutPainter({required this.incomeRatio, required this.expenseRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 30.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);
    final incomePaint = Paint()..color = AppColors.incomeGreen..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    final expensePaint = Paint()..color = AppColors.expenseRed..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    const start = -math.pi / 2;
    final incomeAngle = 2 * math.pi * incomeRatio;
    final expenseAngle = 2 * math.pi * expenseRatio;
    canvas.drawArc(rect, start, incomeAngle, false, incomePaint);
    canvas.drawArc(rect, start + incomeAngle, expenseAngle, false, expensePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}