import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';

import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'package:perlog/features/metadata/widgets/upload_preview.dart';

class ImageUploadFinished extends StatelessWidget {
  const ImageUploadFinished({super.key, this.imageData});

  final MetadataImageData? imageData;

@override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);
    final hasImage = imageData != null;

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
                    // 이전 버튼 위 여백 제거
                    MetadataBackButton(
                      onTap: () => context.go(
                        '${Routes.metadata}/${Routes.imageUpload}',
                      ),
                    ),
                    SizedBox(height: AppSpacing.large(context)),
                    Text(
                      '퍼로그님, 오늘 하루는 어떠셨나요?',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    SizedBox(height: AppSpacing.small(context)),
                    Text(
                      '오늘은 2025년 1월 15일 목요일이에요.',
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {},
                          child: !hasImage
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '이미지 없음',
                                      style: AppTextStyles.body20Medium
                                          .copyWith(color: AppColors.subFont),
                                    ),
                                  ],
                                )
                              : UploadPreview(
                                  imageProvider: NetworkImage(
                                    imageData!.publicUrl,
                                  ),
                                  imageWidth: imageData!.width,
                                  imageHeight: imageData!.height,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 하단 버튼 분리 및 색상 통일
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                0,
                AppSpacing.horizontal,
                screenPadding.bottom,
              ),
              child: BottomButton(
                text: '다음으로',
                onPressed: hasImage
                    ? () => context.go(
                        '${Routes.metadata}/${Routes.ocrLoading}',
                        extra: imageData,
                      )
                    : () {},
                enabled: hasImage,
                backgroundColor: hasImage
                    ? AppColors.subBackground
                    : AppColors.background,
                borderColor: hasImage
                    ? AppColors.subBackground
                    : AppColors.subFont,
                textColor: hasImage ? AppColors.mainFont : AppColors.subFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
