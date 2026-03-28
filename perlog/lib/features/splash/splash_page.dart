import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/domain/app_start/app_start_service.dart';
import 'package:perlog/domain/app_start/app_route_result.dart';

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

    final result = await AppStartService.getInitialRoute();

    if (!mounted) return;

    switch (result) {
      case AppRouteResult.login:
        context.go(Routes.login);
        break;

      case AppRouteResult.onboarding:
        context.go('${Routes.onboarding}/${Routes.profile}');
        break;

      case AppRouteResult.pinCheck:
        context.go('${Routes.onboarding}/${Routes.pinCheck}');
        break;

      case AppRouteResult.home:
        context.go(Routes.home);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Per-Log',
          style: AppTextStyles.headline50.copyWith(
            color: AppColors.mainFont,
          ),
        ),
      ),
    );
  }
}