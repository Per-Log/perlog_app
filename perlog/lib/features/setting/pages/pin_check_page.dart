import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';

class PinCheckPage extends StatelessWidget {
  const PinCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('비밀번호 확인'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Pin Check Page'),
      ),
    );
  }
}