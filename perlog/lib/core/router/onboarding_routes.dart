import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/onboarding/pages/pages.dart';

final onboardingRoutes = [
  GoRoute(
    path: Routes.login,
    pageBuilder: (_, __) =>
        const NoTransitionPage(child: KakaoLoginPage()),
  ),

  GoRoute(
    path: Routes.onboarding,
    redirect: (context, state) {
      if (state.uri.toString() == Routes.onboarding) {
        return '${Routes.onboarding}/${Routes.profile}';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.profile,
        builder: (_, __) => const OnboardingProfilePage(),
      ),
      GoRoute(
        path: Routes.pinSet,
        builder: (_, __) => const PinSetPage(),
      ),
      GoRoute(
        path: Routes.pinConfirm,
        builder: (_, __) => const PinConfirmPage(),
      ),
      GoRoute(
        path: Routes.pinCheck,
        builder: (_, __) => const PinCheckPage(),
      ),
    ],
  ),
];
