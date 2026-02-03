// 변경 전 perlog/lib/features/main/perfume_shelf_page.dart

import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                'Main 선반  page',
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
