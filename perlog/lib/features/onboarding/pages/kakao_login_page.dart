import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';

class KakaoLoginPage extends StatelessWidget {
  const KakaoLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                'Per-Log',
                style: AppTextStyles.headline50.copyWith(
                  color: AppColors.mainFont,
                ),
              ),
            ),

            /// 하단 카카오 로그인 이미지 (탭 가능)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: AppSpacing.bottomButton,
                child: GestureDetector(
                  onTap: () {
                    // TODO: 나중에 카카오 로그인 로직
                    context.go(Routes.onboarding); // 임시 라우팅
                  },
                  child: Image.asset(
                    'assets/images/kakao_login.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
