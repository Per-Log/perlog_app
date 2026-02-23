import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KakaoLoginPage extends StatelessWidget {
  const KakaoLoginPage({super.key});

  Future<void> _signInWithKakao(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
          
      // 1. 카카오로부터 사용자 정보(이름 등) 가져오기
      User user = await UserApi.instance.me();
      String nickname = user.kakaoAccount?.profile?.nickname ?? "사용자";
      String kakaoId = user.id.toString(); // 고유 식별자

      // 2. 휴대폰 본체(SharedPreferences)에 정보 저장하기
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userNickname', nickname);
      await prefs.setString('userId', kakaoId);

      print('저장 완료: $nickname님 환영합니다!');

      if (context.mounted) {
        context.go(Routes.onboarding);
      }
    } catch (error) {
      print('카카오 로그인 실패: $error');
      
      // 사용자가 의도적으로 취소한 경우 처리
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      
      // 에러 알림 (선택 사항)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카카오 로그인에 실패했습니다.')),
        );
      }
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

            /// 하단 카카오 로그인 이미지 (탭 가능)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: AppSpacing.bottomButtonPadding(context),
                child: GestureDetector(
                  onTap: () => _signInWithKakao(context),
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
