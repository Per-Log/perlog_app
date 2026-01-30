import 'package:flutter/material.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '메인 화면 (Shell)',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
