import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _routeAfterSplash();
  }

  Future<void> _routeAfterSplash() async {

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // TODO: splash 이후 라우팅용 상태관리
    // final bool isFirstLaunch = false;
    // final bool isLoggedIn = true;
    // final bool hasPin = true;

    // if (isFirstLaunch || !isLoggedIn) {
    //   // 최초 접속 or 로그아웃 상태
    //   context.go(Routes.login);
    //   return;
    // }

    // if (hasPin) {
    //   // PIN 설정된 사용자
    //   context.go('${Routes.onboarding}/${Routes.pinConfirm}');
    //   return;
    // }


    // [테스트용 상태 설정]
    const bool isLoggedIn = true; // 로그인이 되어 있다고 가정
    const bool hasPin = true;     // PIN이 설정되어 있다고 가정

    if (!isLoggedIn) {
      // 로그인이 안 되어 있으면 -> 로그인 화면으로
      context.go(Routes.login);
      return;
    }

    if (hasPin) {
      // PIN이 설정되어 있으면 -> 비밀번호 입력(확인) 화면으로
      // 일단 비밀번호 재확인 페이지로 라우팅 해놓음
      context.go('${Routes.onboarding}/${Routes.pinConfirm}');
      return;
    }

    context.go(Routes.shell);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Per-Log',
          style: AppTextStyles.headline50.copyWith(color: AppColors.mainFont)
        ),
      ),
    );
  }
}
