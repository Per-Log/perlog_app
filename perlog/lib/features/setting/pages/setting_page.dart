import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                'Settings page',
                style: AppTextStyles.headline50.copyWith(
                  color: AppColors.mainFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
