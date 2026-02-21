import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'package:perlog/features/metadata/pages/pages.dart';

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
      GoRoute(path: Routes.calendar, builder: (_, __) => const Calendar()),
      GoRoute(
        path: Routes.imageUpload,
        builder: (_, state) =>
            ImageUpload(args: state.extra as MetadataImageData?),
      ),
      GoRoute(
        path: Routes.imageUploadFinished,
        builder: (_, state) =>
            ImageUploadFinished(args: state.extra as MetadataImageData?),
      ),
      GoRoute(
        path: Routes.imageUploadEdit,
        builder: (_, state) =>
            ImageUploadEdit(args: state.extra as MetadataImageData?),
      ),
      GoRoute(
        path: Routes.ocrLoading,
        builder: (_, state) =>
            OCRLoading(args: state.extra as MetadataImageData?),
      ),
      GoRoute(
        path: Routes.diaryAnalysis,
        builder: (_, state) =>
            DiaryAnalysis(args: state.extra as MetadataImageData?),
      ),
    ],
  ),
];
