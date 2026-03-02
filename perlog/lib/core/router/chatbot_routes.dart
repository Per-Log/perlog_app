import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'package:perlog/features/chatbot/pages/chatbot_shell.dart';
import 'package:perlog/features/chatbot/pages/pages.dart';
import 'routes.dart';

final chatbotRoutes = [
  ShellRoute(
    pageBuilder: (context, state, child) =>
        fadeTransitionPage(
          key: state.pageKey,
          child: ChatbotShell(child: child),
        ),
    routes: [
      GoRoute(
        path: Routes.chatbot,
        pageBuilder: (context, state) =>
            fadeTransitionPage(
              key: state.pageKey,
              child: const Chatbot(),
            ),
      ),
    ],
  ),
];