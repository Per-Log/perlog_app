import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'package:perlog/features/metadata/pages/pages.dart';

import '../../features/metadata/pages/test.dart';
import '../../features/metadata/pages/test_supabase.dart';

final metadataRoutes = [
  GoRoute(
    path: Routes.metadata,
    redirect: (context, state) {
      if (state.uri.toString() == Routes.metadata) {
        return '${Routes.metadata}/${Routes.calendar}';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.calendar,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const CalendarPage(),
        ),
      ),
      GoRoute(
        path: Routes.imageUpload,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: ImageUpload(
            args: state.extra as MetadataImageData?,
          ),
        ),
      ),
      GoRoute(
        path: Routes.imageUploadEdit,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: ImageUploadEdit(
            args: state.extra as MetadataImageData?,
          ),
        ),
      ),
      GoRoute(
        path: Routes.ocrLoading,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: OCRLoading(
            args: state.extra as MetadataImageData?,
          ),
        ),
      ),
      GoRoute(
        path: Routes.ocrCheck,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: OCRCheckPage(args: state.extra as MetadataImageData?),
        ),
      ),
      GoRoute(
        path: Routes.diaryAnalysis,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: DiaryAnalysis(
            args: state.extra as MetadataImageData?,
          ),
        ),
      ),
      GoRoute(path: Routes.test, builder: (_, __) => const Test()),
      GoRoute(path: Routes.test_supabase, builder: (_, __) => const TestSupabasePage()),
    ],
  ),
];