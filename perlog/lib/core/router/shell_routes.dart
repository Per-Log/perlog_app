import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'package:perlog/features/home/pages/home_shell.dart';
import 'package:perlog/features/home/pages/home_page.dart';
import 'package:perlog/features/setting/pages/setting_page.dart';
import 'package:perlog/features/mydiary/pages/pages.dart';
import 'routes.dart';

final shellRoutes = [
  ShellRoute(
    pageBuilder: (context, state, child) => fadeTransitionPage(
      key: state.pageKey,
      child: HomeShell(child: child),
    ),
    routes: [
      /// [홈 탭]
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),

      /// [나의 일기 탭]
      GoRoute(
        path: Routes.myDiaryMain,
        redirect: (context, state) {
          if (state.uri.path == Routes.myDiaryMain) {
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

      /// [설정 탭]
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const Settings(),
        ),
      ),
    ],
  ),
];