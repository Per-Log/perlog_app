import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/spacing_test_page.dart';
import 'package:perlog/features/home/home_shell.dart';
import 'package:perlog/features/onboarding/pages/kakao_login_page.dart';
import 'package:perlog/features/onboarding/pages/onboarding_profile_page.dart';
import 'package:perlog/features/onboarding/pages/pin_confirm_page.dart';
import 'package:perlog/features/onboarding/pages/pin_set_page.dart';
import 'package:perlog/features/splash/splash_page.dart';
import 'routes.dart';

bool isOnboarded = true;

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    /// Splash
    GoRoute(
      path: Routes.splash,
      builder: (_, __) => const SplashPage(),
    ),

    /// Kakao Login
    GoRoute(
      path: Routes.login,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: KakaoLoginPage(),
      ),
    ),

/// Onboarding Flow
    GoRoute(
      path: Routes.onboarding,
      redirect: (context, state) {
        if (state.uri.toString() == Routes.onboarding) {
          return '${Routes.onboarding}/${Routes.profile}';
        }
        return null;
      },
      routes: [
        /// 이미지 / 별명 / 알림 / 잠금
        GoRoute(
          path: Routes.profile,
          builder: (_, __) => const OnboardingProfilePage(),
        ),

        /// PIN 설정
        GoRoute(
          path: Routes.pinSet,
          builder: (_, __) => const PinSetPage(),
        ),

        /// PIN 확인
        GoRoute(
          path: Routes.pinConfirm,
          builder: (_, __) => const PinConfirmPage(),
        ),
      ],
    ),

    /// Onboarding 완료 후 진입
    GoRoute(
      path: Routes.shell,
      builder: (_, __) => const HomeShell(),
    ),


    ////// debug
    GoRoute(
    path: Routes.paddingTest,
    builder: (_, __) => const PaddingTestPage(),
    ),
  ],
);
