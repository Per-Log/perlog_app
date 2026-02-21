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
                      ),
                    ),
                    SizedBox(height: AppSpacing.small(context)),
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
                          child: imageData == null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '이미지 없음',
                                      style: AppTextStyles.body20Medium.copyWith(
                                        color: AppColors.subFont,
                                      ),
                                    ),
                                  ],
                                )
                              : UploadPreview(
                                  imageProvider: NetworkImage(imageData!.publicUrl),
                                  imageWidth: imageData!.width,
                                  imageHeight: imageData!.height,
                                ),
                              
                        ),
                      ),
                    ),
                    SizedBox(height: 27),
                    BottomButton(
                      text: '다음으로',
                      onPressed: imageData == null
                          ? () {}
                          : () => context.go(
                              '${Routes.metadata}/${Routes.ocrLoading}',
                              extra: imageData,
                            ),
                      enabled: imageData != null,
                      backgroundColor: AppColors.background,
                      borderColor: imageData == null
                          ? AppColors.subFont
                          : AppColors.mainFont,
                      textColor: imageData == null
                          ? AppColors.subFont
                          : AppColors.mainFont,
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
