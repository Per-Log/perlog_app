import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'package:perlog/features/mydiary/pages/pages.dart';
import 'routes.dart';

final myDiaryRoutes = [
  GoRoute(
    path: Routes.myDiaryMain,
    redirect: (context, state) {
      if (state.uri.toString() == Routes.myDiaryMain) {
        return '${Routes.myDiaryMain}/${Routes.myDiary}';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.myDiary,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const MyDiary(),
        ),
      ),
      GoRoute(
        path: Routes.myAnalysis,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const MyAnalysis(),
        ),
      ),
      GoRoute(
        path: Routes.myCalendar,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const MyCalendar(),
        ),
      ),
    ],
  ),
];