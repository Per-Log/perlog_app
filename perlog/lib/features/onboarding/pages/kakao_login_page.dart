import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/domain/auth/auth_service.dart';

class KakaoLoginPage extends StatelessWidget {
  const KakaoLoginPage({super.key});

  // 임시 로그인 처리
  Future<void> _handleLogin(BuildContext context) async {
    // TODO: 카카오 로그인 연동 예정
    const fakeToken = 'test_token';

    await AuthService.login(accessToken: fakeToken);

    if (!context.mounted) return;

    // 로그인 이후 흐름은 Splash 로직 재사용
    context.go(Routes.splash);
  }

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

            // 카카오 로그인 버튼
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: AppSpacing.bottomButtonPadding(context),
                child: GestureDetector(
                  onTap: () => _handleLogin(context),
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