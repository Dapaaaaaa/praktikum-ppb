import 'package:flutter/material.dart';
import 'package:pertemuan_2/views/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
