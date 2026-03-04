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
  const OCRLoading({super.key, this.args});
  final MetadataImageData? args; // 변수명 일치

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
      context.go(
        '${Routes.metadata}/${Routes.diaryAnalysis}',
        extra: widget.args,
      );
    } else {
      // 실패 시: 이미지 편집(수정) 페이지로 자동 이동
      context.go(
        '${Routes.metadata}/${Routes.imageUploadEdit}',
        extra: widget.args,
      );
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
                  screenPadding.top, // 상단 여백 달력과 동일
                  screenPadding.right,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이전 버튼 위 여백 제거
                    MetadataBackButton(
                      onTap: () =>
                          context.go('${Routes.metadata}/${Routes.calendar}'),
                    ),
                    SizedBox(height: AppSpacing.large(context)),
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
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 393,
                          height: double.infinity, // 세로만 꽉 채우기
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.subBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: widget.args?.publicUrl == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '이미지 분석 중...',
                                        style: AppTextStyles.body20Medium
                                            .copyWith(color: AppColors.subFont),
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
                                    imageProvider: NetworkImage(
                                      widget.args!.publicUrl!,
                                    ),
                                    imageWidth: widget.args!.width!,
                                    imageHeight: widget.args!.height!,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 프로그레스 바
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
                    const SizedBox(height: 24), // 💡 하단 화면 엣지와의 여백 추가
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
