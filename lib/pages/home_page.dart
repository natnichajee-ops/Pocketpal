import 'package:flutter/material.dart';
import 'transaction_page.dart';

const mainColor = Color(0xFF6FB7B2);
const bgColor = Color(0xFFEFF7F6);
const textColor = Color(0xFF302A4C);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. โลโก้พื้นหลัง
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

          // 2. เนื้อหาหลัก
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 💰 Card สรุปยอดเงิน
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(163, 217, 211, 1),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                          style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        // กล่องสีขาวแสดงยอดเงิน
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Column(
                            children: [
                              Text('this month', style: TextStyle(color: Colors.grey, fontSize: 20)),
                              SizedBox(height: 1),
                              Text(
                                '9999.00 THB',
                                style: TextStyle(
                                  fontSize: 35,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // แถว Income / Paid
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InfoBox(title: 'income', amount: '9999.00'),
                            InfoBox(title: 'paid', amount: '1.00'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ➕ ปุ่ม Create Transaction
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD66B),
                      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, anim, secAnim) => const TransactionPage(),
                          transitionsBuilder: (context, anim, secAnim, child) {
                            var tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.easeOutQuart));
                            return SlideTransition(position: anim.drive(tween), child: child);
                          },
                        ),
                      );
                    },
                    child: const Text(
                      '+ CREATE A TRANSACTION',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '$amount THB',
            style: const TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
} 