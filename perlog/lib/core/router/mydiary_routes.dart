import 'package:go_router/go_router.dart';
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
      GoRoute(path: Routes.myDiary, builder: (_, __) => const MyDiary()),
      GoRoute(path: Routes.myAnalysis, builder: (_, __) => const MyAnalysis()),
      GoRoute(path: Routes.myCalendar, builder: (_, __) => const MyCalendar()),
    ],
  ),
];
