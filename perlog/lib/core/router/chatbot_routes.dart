import 'package:go_router/go_router.dart';
import 'package:perlog/features/chatbot/pages/chatbot_shell.dart';
import 'package:perlog/features/chatbot/pages/pages.dart';
import 'routes.dart';

final chatbotRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      return ChatbotShell(child: child);
    },
    routes: [
      GoRoute(
        path: Routes.chatbot,
        builder: (_, __) => const Chatbot(),
      ),
    ],
  ),
];