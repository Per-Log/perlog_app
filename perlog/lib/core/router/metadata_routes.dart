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
      GoRoute(path: Routes.imageUpload, builder: (_, __) => const ImageUpload()),
      GoRoute(
        path: Routes.imageUploadFinished,
        builder: (_, state) =>
            ImageUploadFinished(imageData: state.extra as MetadataImageData?),
      ),
      GoRoute(
        path: Routes.imageUploadEdit,
        builder: (_, __) => const ImageUploadEdit(),
      ),
      GoRoute(
        path: Routes.ocrLoading,
        builder: (_, state) =>
            OCRLoading(imageData: state.extra as MetadataImageData?),
      ),
      GoRoute(
        path: Routes.diaryAnalysis,
        builder: (_, __) => const DiaryAnalysis(),
      ),
    ],
  ),
];
