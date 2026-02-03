import 'package:go_router/go_router.dart';
import 'package:perlog/features/splash/splash_page.dart';
import 'routes.dart';

final splashRoutes = [
  GoRoute(
    path: Routes.splash,
    builder: (_, __) => const SplashPage(),
  ),
];
