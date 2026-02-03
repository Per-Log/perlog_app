import 'package:go_router/go_router.dart';

import 'routes.dart';
import 'splash_routes.dart';
import 'onboarding_routes.dart';
import 'shell_routes.dart';
import 'metadata_routes.dart';
import 'mydiary_routes.dart';
import 'chatbot_routes.dart';
import 'debug_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    ...splashRoutes,
    ...onboardingRoutes,
    ...shellRoutes,
    ...metadataRoutes,
    ...myDiaryRoutes,
    ...chatbotRoutes,
    ...debugRoutes,
  ],
);
