import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/domain/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KakaoLoginPage extends StatelessWidget {
  const KakaoLoginPage({super.key});

  Future<void> _handleLogin(BuildContext context) async {
    try {
      debugPrint('[LOGIN] 카카오 로그인 시작');

      // flutter run -d chrome --web-port=3000 --dart-define=DEV=true

      String userId;
      const bool isDev = bool.fromEnvironment('DEV');

      if (isDev) {
        userId = "dev_user_1";
        debugPrint('[LOGIN] DEV MODE');
      } else {
        debugPrint('[LOGIN] 카카오 로그인 시작');

        // 카카오 유저 정보 가져오기
        final user = await UserApi.instance.me();
        userId = "kakao_${user.id}";
        debugPrint('[LOGIN] userId 생성: $userId');
      }

      // SharedPreferences 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", userId);

      // TODO : Supabase 연동

      // Auth 상태 반영
      await AuthService.login(accessToken: userId);
      debugPrint('[LOGIN] AuthService 로그인 완료');

      if (!context.mounted) return;

      context.go(Routes.splash);
    } catch (e) {
      debugPrint('[LOGIN ERROR] $e');
    }
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
