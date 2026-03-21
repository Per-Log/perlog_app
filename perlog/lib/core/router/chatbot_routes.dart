import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'package:perlog/features/chatbot/pages/chatbot_shell.dart';
import 'package:perlog/features/chatbot/pages/chatbot_todiary.dart';
import 'package:perlog/features/chatbot/pages/pages.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'routes.dart';

final chatbotRoutes = [
  /// 🔹 Shell (chatbot UI 전용)
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

  GoRoute(
    path: '/chatbot-to-diary',
    pageBuilder: (context, state) =>
        fadeTransitionPage(
          key: state.pageKey,
          child: ChatbotTodiary(
            args: state.extra as MetadataImageData?,
          ),
        ),
  ),
];