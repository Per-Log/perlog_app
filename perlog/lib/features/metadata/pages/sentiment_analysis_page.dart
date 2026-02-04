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
        child: SingleChildScrollView(
          // 요소가 많아질 경우를 대비해 스크롤 추가
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              screenPadding.left,
              screenPadding.top,
              screenPadding.right,
              screenPadding.bottom + 20, // 하단 여유 공간
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬 통일
              children: [
                // 1. 날짜 및 헤더
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

                // 2. 향수 설명 영역 (Row)
                Row(
                  children: [
                    const SizedBox(width: 24),

                    Image.asset(
                      'assets/icons/perfume.png',
                      height: 52,
                      width: 52,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.wine_bar,
                        size: 52,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      // 텍스트가 길어질 경우를 대비
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

                // 3. 해시태그 바
                Container(
                  width: double.infinity, // 가로 꽉 차게 변경
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

                // 4. 메인 분석 결과 카드 (중앙 정렬 위해 Center 유지)
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

                // 5. 하단 버튼
                BottomButton(
                  text: '홈으로',
                  onPressed: () => context.go(Routes.home),
                  enabled: true,
                  backgroundColor: AppColors.background,
                  borderColor: AppColors.mainFont,
                  textColor: AppColors.mainFont,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
