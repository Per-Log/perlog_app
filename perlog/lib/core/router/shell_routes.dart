import 'package:go_router/go_router.dart';
import 'package:perlog/features/home/pages/home_shell.dart';
import 'package:perlog/features/home/pages/home_page.dart';
import 'package:perlog/features/setting/pages/setting_page.dart';
import 'routes.dart';

final shellRoutes = [
  /// Onboarding 완료 후 진입
  GoRoute(
    path: Routes.shell,
    builder: (_, __) => const HomeShell(),
  ),

  /// Main
  GoRoute(
    path: Routes.home,
    builder: (_, __) => const HomePage(),
  ),

  /// Settings
  GoRoute(
    path: Routes.settings,
    builder: (_, __) => const Settings(),
  ),
];
