import 'package:flutter/material.dart';

class PerfumeShelf extends StatelessWidget {
  const PerfumeShelf({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/perfume_shelf.png',
      width: double.infinity,
      fit: BoxFit.contain,
    );
  }
}
