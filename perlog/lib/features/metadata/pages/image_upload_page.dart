import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  // 1. 이미지 업로드 상태를 관리하는 변수
  bool _isImageUploaded = false;

  void _handleImageUpload() {
    // 실제로는 여기서 image_picker 패키지 등을 사용합니다.
    setState(() {
      _isImageUploaded = true; // 이미지 업로드 완료 시 true로 변경
    });
  }

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
                      onTap: () =>
                          context.go('${Routes.metadata}/${Routes.calendar}'),
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

                    // 2. 이미지 업로드 버튼 (이미지가 업로드되면 UI가 변경됨)
                    Center(
                      child: SizedBox(
                        width: 393,
                        height: 498,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isImageUploaded
                                ? const Color(0xFFE5D9C5) // 업로드 후 조금 더 진한 색
                                : AppColors.subBackground,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // 업로드 후 테마에 맞춰 테두리 추가 가능
                            side: _isImageUploaded
                                ? BorderSide(
                                    color: AppColors.mainFont,
                                    width: 1,
                                  )
                                : BorderSide.none,
                          ),
                          onPressed: _handleImageUpload,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 이미지가 업로드되면 아이콘을 체크 표시로 변경
                              Icon(
                                _isImageUploaded
                                    ? Icons.check_circle
                                    : Icons.camera_alt_outlined,
                                size: 48,
                                color: _isImageUploaded
                                    ? AppColors.mainFont
                                    : AppColors.subFont,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _isImageUploaded ? '이미지 선택 완료' : '이미지 업로드',
                                style: AppTextStyles.body20Medium.copyWith(
                                  color: _isImageUploaded
                                      ? AppColors.mainFont
                                      : AppColors.subFont,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 27),

                    // 3. 하단 버튼 (이미지 업로드 여부에 따라 색상 변경)
                    BottomButton(
                      text: '다음으로',
                      onPressed: _isImageUploaded
                          ? () => context.go(
                              '${Routes.metadata}/${Routes.imageUploadFinished}',
                            )
                          : () {}, // 미업로드 시 동작 안 함 (혹은 토스트 메시지)
                      // 이미지 업로드 여부에 따라 디자인 변경
                      enabled: _isImageUploaded,
                      backgroundColor: _isImageUploaded
                          ? AppColors
                                .background // 활성화 시 진한 배경
                          : AppColors.background, // 비활성화 시 연한 배경
                      textColor: _isImageUploaded
                          ? AppColors
                                .mainFont // 활성화 시 흰색 글자
                          : AppColors.subFont, // 비활성화 시 연한 글자
                      borderColor: _isImageUploaded
                          ? AppColors.mainFont
                          : AppColors.subFont,
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
