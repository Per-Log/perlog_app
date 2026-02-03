import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/router/routes.dart';

class OCRLoading extends StatelessWidget {
  const OCRLoading({super.key});

  @override
  Widget build(BuildContext context) {
    bool lockEnabled = true;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Text('OCR 인식 수정사항'),
                ElevatedButton(
                  onPressed: () {
                    if (lockEnabled) {
                      context.go('${Routes.metadata}/${Routes.diaryAnalysis}');
                    } else {
                      context.go(Routes.shell);
                    }
                  },
                  child: const Text('다음'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
