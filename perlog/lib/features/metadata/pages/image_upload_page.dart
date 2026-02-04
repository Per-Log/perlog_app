import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';

class ImageUpload extends StatelessWidget {
  const ImageUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            MetadataBackButton(onTap: () => context.go(Routes.home)),
            Center(
              child: Text(
                'MyAnalysis page',
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
