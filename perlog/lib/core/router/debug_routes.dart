import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/spacing_test_page.dart';
import 'routes.dart';

final debugRoutes = [
  GoRoute(
    path: Routes.paddingTest,
    builder: (_, __) => const PaddingTestPage(),
  ),
];
