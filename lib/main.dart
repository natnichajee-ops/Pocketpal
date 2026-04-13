import 'package:flutter/material.dart';
import 'Pages/loading_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PocketPal',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Jua',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF302A4C)),
          bodyLarge: TextStyle(color: Color(0xFF302A4C)),
          titleLarge: TextStyle(color: Color(0xFF302A4C)),
        ),
      ),
      home: const LoadingPage(),
    );
  }
}
