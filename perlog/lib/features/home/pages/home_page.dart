// 변경 전 perlog/lib/features/main/perfume_shelf_page.dart

import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: AppSpacing.card,
                child: BottomButton(
                  text: "임시 업로드용 버튼",
                  onPressed: () {
                    context.go('${Routes.metadata}/${Routes.calendar}');
                  },
                  enabled: true,
                  backgroundColor: AppColors.background,
                  borderColor: AppColors.mainFont,
                  textColor: AppColors.mainFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
