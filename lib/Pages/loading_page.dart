import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F6),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 250,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.account_balance_wallet,
                  size: 100,
                  color: Color(0xFF6FB7B2),
                );
              },
            ),
            const SizedBox(height: 30),

            const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6FB7B2)),
            ),

            const SizedBox(height: 20),
            const Text(
              'Loading your financial journey...',
              style: TextStyle(
                fontFamily: 'Jua',
                color: Color(0xFF302A4C),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}