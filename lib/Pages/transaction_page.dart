import 'package:flutter/material.dart';
import 'add_expense_page.dart';
import 'category_page.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2D8D8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'OPTION',
          style: TextStyle(
            color: Color(0xFF302A4C),
            fontWeight: FontWeight.bold,
            fontFamily: 'Jua',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionCard(
              context,
              title: "ADD INCOME +",
              buttonText: "ADD NEW INCOME",
              cardColor: const Color(0xFFB2D8D8),
              buttonColor: const Color(0xFFFDD87A),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryPage()),
                );
              },
            ),

            const SizedBox(height: 30),

            _buildOptionCard(
              context,
              title: "ADD EXPENSE -",
              buttonText: "ADD NEW EXPENSE",
              cardColor: const Color(0xFFF4A7B0),
              buttonColor: const Color(0xFFFDD87A),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExpensePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String buttonText,
    required Color cardColor,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF302A4C),
              fontFamily: 'Jua',
            ),
          ),
          const SizedBox(height: 20),

          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF302A4C),
                  fontFamily: 'Jua',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
