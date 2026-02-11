import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';

import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';

class ImageUploadEdit extends StatelessWidget {
  const ImageUploadEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenPadding.left,
                  screenPadding.top,
                  screenPadding.right,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.vertical * 2),
                    MetadataBackButton(
                      onTap: () => context.go(
                        '${Routes.metadata}/${Routes.imageUpload}',
                      ), // GoRouter를 사용한다면 context.pop() 추천
                    ),
                    SizedBox(height: AppSpacing.small(context)),
                    Text(
                      '글씨가 잘 보이지 않아요.',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),

                    ///SizedBox(height: AppSpacing.small(context)),
                    Text(
                      '조금 더 밝은 곳에서,',
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    Text(
                      '종이가 화면에 가득 차도록 다시 찍어볼까요?',
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    SizedBox(height: AppSpacing.vertical),
                    Center(
                      child: SizedBox(
                        width: 393,
                        height: 498,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.subBackground,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '이미지 업로드',
                                style: AppTextStyles.body20Medium.copyWith(
                                  color: AppColors.subFont,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 28,
                                color: AppColors.subFont,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 27),
                    BottomButton(
                      text: '다음으로',
                      onPressed: () =>
                          context.go('${Routes.metadata}/${Routes.ocrLoading}'),
                      enabled: true,
                      backgroundColor: AppColors.background,
                      borderColor: AppColors.mainFont,
                      textColor: AppColors.mainFont,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
