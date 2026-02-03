import 'package:go_router/go_router.dart';
import 'package:perlog/features/chatbot/pages/pages.dart';
import 'routes.dart';

final chatbotRoutes = [
  GoRoute(
    path: Routes.chatbot,
    builder: (_, __) => const Chatbot(),
  ),
  GoRoute(
    path: Routes.chatbotUse,
    builder: (_, __) => const ChatbotUse(),
  ),
];
