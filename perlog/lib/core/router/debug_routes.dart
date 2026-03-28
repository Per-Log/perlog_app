import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/spacing_test_page.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'routes.dart';

import 'package:perlog/features/mydiary/ui/diary_font_test_page.dart';

final debugRoutes = [
  GoRoute(
    path: Routes.paddingTest,
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const PaddingTestPage(),
    ),
  ),

  GoRoute(
    path: Routes.diaryFontTest,
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const DiaryFontTestPage(),
    ),
  ),
];