import 'package:flutter/material.dart';
import 'transaction_page.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../models/database_helper.dart';
import 'summaries_page.dart';
import 'profile_page.dart';

const mainColor = Color(0xFF6FB7B2);
const bgColor = Color(0xFFEFF7F6);
const textColor = Color(0xFF302A4C);

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, this.username = ''});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final DatabaseHelper _db = DatabaseHelper();

  double _totalIncome = 0;
  double _totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _loadTotals();
  }

  // ✅ ดึงยอดรวมจาก database จริง
  Future<void> _loadTotals() async {
    final income = await _db.getTotalIncome();
    final expense = await _db.getTotalExpense();
    setState(() {
      _totalIncome = income;
      _totalExpense = expense;
    });
  }

  @override
  Widget build(BuildContext context) {
    final netBalance = _totalIncome - _totalExpense;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Image.asset(
                'assets/logo.png',
                width: 350,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(163, 217, 211, 1),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your account book',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        // ✅ แสดงยอด net balance จริง
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'this month',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '${netBalance.toStringAsFixed(2)} THB',
                                style: const TextStyle(
                                  fontSize: 35,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // ✅ แสดง income / expense จริง
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InfoBox(
                              title: 'income',
                              amount: _totalIncome.toStringAsFixed(2),
                            ),
                            InfoBox(
                              title: 'paid',
                              amount: _totalExpense.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD66B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 90,
                        vertical: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, anim, secAnim) =>
                              const TransactionPage(),
                          transitionsBuilder: (context, anim, secAnim, child) {
                            var tween = Tween(
                              begin: const Offset(0.0, 1.0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeOutQuart));
                            return SlideTransition(
                              position: anim.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                      // ✅ โหลดยอดใหม่หลังกลับจากหน้า Transaction
                      _loadTotals();
                    },
                    child: const Text(
                      '+ CREATE A TRANSACTION',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SummariesPage()),
            ).then((_) {
              _loadTotals();
              setState(() => _currentIndex = 0);
            });
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(username: widget.username),
              ),
            ).then((_) => setState(() => _currentIndex = 0));
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String title;
  final String amount;
  const InfoBox({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '$amount THB',
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
