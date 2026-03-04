import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'package:perlog/features/splash/splash_page.dart';
import 'routes.dart';

final splashRoutes = [
  GoRoute(
    path: Routes.splash,
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const SplashPage(),
    ),
  ),
];