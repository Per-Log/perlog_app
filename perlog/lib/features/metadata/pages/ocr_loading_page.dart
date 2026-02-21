import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'package:perlog/features/metadata/widgets/upload_preview.dart';

class OCRLoading extends StatefulWidget {
  const OCRLoading({super.key, this.imageData});

  final MetadataImageData? imageData;

  @override
  State<OCRLoading> createState() => _OCRLoadingState();
}

class _OCRLoadingState extends State<OCRLoading> {
  double _progressValue = 0.0;
  Timer? _timer;
  // 50:50 확률로 성공/실패 시뮬레이션 (나중에 API 결과로 대체)
  final bool _isCleanImage = Random().nextDouble() < 0.5;

  @override
  void initState() {
    super.initState();
    _startSimulatedLoading();
  }

  void _startSimulatedLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        if (_progressValue < 1.0) {
          _progressValue += 0.01;
        } else {
          _timer?.cancel();
          _handleNavigation(); // 100% 도달 시 자동 이동 실행
        }
      });
    });
  }

  // 성공/실패 여부에 따른 자동 페이지 이동 처리
  void _handleNavigation() {
    if (_isCleanImage) {
      // 성공 시: 일기 분석 페이지로 자동 이동
      context.go('${Routes.metadata}/${Routes.diaryAnalysis}');
    } else {
      // 실패 시: 이미지 편집(수정) 페이지로 자동 이동
      context.go('${Routes.metadata}/${Routes.imageUploadEdit}');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                      onTap: () => context.go(
                        '${Routes.metadata}/${Routes.imageUpload}',
                      ),
                    ),
                    SizedBox(height: AppSpacing.small(context)),
                    Text(
                      '일기를 읽고 있어요.',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    Text(
                      '잠시만 기다려주세요',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    SizedBox(height: AppSpacing.vertical),
                    // 이미지 영역
                    Center(
                      child: SizedBox(
                        width: 393,
                        height: 498,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.subBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: widget.imageData == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '이미지 분석 중...',
                                      style: AppTextStyles.body20Medium.copyWith(
                                        color: AppColors.subFont,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      size: 28,
                                      color: AppColors.subFont,
                                    ),
                                  ],
                                )
                              : UploadPreview(
                                  imageProvider:
                                      NetworkImage(widget.imageData!.publicUrl),
                                  imageWidth: widget.imageData!.width,
                                  imageHeight: widget.imageData!.height,
                                ),
                              
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 프로그레스 바 (이미지 하단 배치)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progressValue,
                        minHeight: 12,
                        backgroundColor: AppColors.subBackground,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.mainFont,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        '${(_progressValue * 100).toInt()}% 완료',
                        style: AppTextStyles.body14.copyWith(
                          color: AppColors.subFont,
                        ),
                      ),
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
