import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';

class ImageUpload extends StatelessWidget {
  const ImageUpload({super.key});

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
                Text('Calendar page-날짜 선택'),
                ElevatedButton(
                  onPressed: () {
                    if (lockEnabled) {
                      context.go(
                        '${Routes.metadata}/${Routes.imageUploadFinished}',
                      );
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
