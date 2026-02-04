import 'package:go_router/go_router.dart';
import 'package:perlog/features/home/pages/home_shell.dart';
import 'package:perlog/features/home/pages/home_page.dart';
import 'package:perlog/features/setting/pages/setting_page.dart';
import 'package:perlog/features/mydiary/pages/pages.dart';
import 'routes.dart';

final shellRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      // HomeShell 위젯 내부에 'final Widget child;'와 생성자가 선언되어 있어야 합니다.
      return HomeShell(child: child);
    },
    routes: [
      /// [홈 탭]
      GoRoute(
        // 주의: Routes.home이 "/home"이라면 아래처럼 슬래시를 제거한 문자열을 직접 넣거나
        // Routes.dart에서 슬래시가 없는 상수를 별도로 만드시는 것을 추천합니다.
        path: '/home', // ShellRoute의 첫 번째 자식은 절대 경로(/)를 가질 수 있습니다.
        builder: (_, __) => const HomePage(),
      ),

      /// [나의 일기 탭]
      GoRoute(
        path: Routes.myDiaryMain, // 예: '/myDiaryMain'
        redirect: (context, state) {
          if (state.uri.path == Routes.myDiaryMain) {
            return '${Routes.myDiaryMain}/${Routes.myDiary}';
          }
          return null;
        },
        routes: [
          // 자식 경로는 반드시 '상대 경로'여야 합니다 (슬래시 / 제외)
          GoRoute(
            path: Routes.myDiary, // Routes.myDiary는 'myDiary'여야 함
            builder: (_, __) => const MyDiary(),
          ),
          GoRoute(
            path: Routes.myAnalysis, // 'myAnalysis'
            builder: (_, __) => const MyAnalysis(),
          ),
          GoRoute(
            path: Routes.myCalendar, // 'myCalendar'
            builder: (_, __) => const MyCalendar(),
          ),
        ],
      ),

      /// [설정 탭]
      GoRoute(path: '/settings', builder: (_, __) => const Settings()),
    ],
  ),
];
// final shellRoutes = [

/// Onboarding 완료 후 진입
//   GoRoute(
//     path: Routes.shell,
//     builder: (_, __) => const HomeShell(),
//   ),
//
//   /// Main
//   GoRoute(
//     path: Routes.home,
//     builder: (_, __) => const HomePage(),
//   ),
//
//   /// Settings
//   GoRoute(
//     path: Routes.settings,
//     builder: (_, __) => const Settings(),
//   ),
// ];
