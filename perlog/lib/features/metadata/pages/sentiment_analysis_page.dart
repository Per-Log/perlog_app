import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';

class DiaryAnalysis extends StatelessWidget {
  const DiaryAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  screenPadding.left,
                  screenPadding.top,
                  screenPadding.right,
                  0, // 하단 버튼이 고정되므로 스크롤뷰 안의 바텀 패딩을 없앱니다.
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이전 버튼은 기획상 없으므로 바로 텍스트 시작
                    Text(
                      '2025년 1월 15일 목요일,',
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '퍼로그님의 하루예요.',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),

                    SizedBox(height: AppSpacing.vertical),

                    // 향수 설명 영역 (Row)
                    Row(
                      children: [
                        const SizedBox(width: 24),
                        Image.asset(
                          'assets/icons/perfume.png',
                          height: 52,
                          width: 52,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.wine_bar,
                                size: 52,
                                color: Colors.brown,
                              ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '~~한 하루였군요!',
                                style: AppTextStyles.body12.copyWith(
                                  color: AppColors.mainFont,
                                ),
                              ),
                              Text(
                                '오늘의 향수 잡다한 설명 왈라라랄랄',
                                style: AppTextStyles.body12.copyWith(
                                  color: AppColors.mainFont,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.vertical),

                    // 해시태그 바
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.subBackground,
                      ),
                      child: Center(
                        child: Text(
                          '#복숭아향 #과일향 #기쁜 #설렘',
                          style: AppTextStyles.body18SemiBold.copyWith(
                            color: AppColors.mainFont,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.vertical),

                    // 메인 분석 결과 카드
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.subBackground,
                        ),
                        child: Center(
                          child: Text(
                            '여기에 분석 상세 내용이 들어갑니다.',
                            style: AppTextStyles.body18SemiBold.copyWith(
                              color: AppColors.mainFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // 하단 버튼 (스크롤 뷰 바깥, 화면 하단 고정)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                0,
                AppSpacing.horizontal,
                screenPadding.bottom,
              ),
              child: BottomButton(
                text: '홈으로',
                onPressed: () => context.go(Routes.home),
                enabled: true,
                // 활성화 시 캘린더 페이지와 동일한 색상 정책
                backgroundColor: AppColors.subBackground,
                borderColor: AppColors.subBackground,
                textColor: AppColors.mainFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
