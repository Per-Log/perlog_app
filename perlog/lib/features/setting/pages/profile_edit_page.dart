import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('나의 정보'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Profile Edit Page'),
      ),
    );
  }
}