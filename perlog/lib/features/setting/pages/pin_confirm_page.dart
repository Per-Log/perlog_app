import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';

class PinConfirmPage extends StatelessWidget {
  const PinConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('비밀번호 확정'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Pin Confirm Page'),
      ),
    );
  }
}