import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/onboarding/pages/pages.dart';

final onboardingRoutes = [
  GoRoute(
    path: Routes.login,
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const KakaoLoginPage(),
    ),
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
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const OnboardingProfilePage(),
        ),
      ),
      GoRoute(
        path: Routes.pinSet,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const PinSetPage(),
        ),
      ),
      GoRoute(
        path: Routes.pinConfirm,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const PinConfirmPage(),
        ),
      ),
      GoRoute(
        path: Routes.pinCheck,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const PinCheckPage(),
        ),
      ),
    ],
  ),
];