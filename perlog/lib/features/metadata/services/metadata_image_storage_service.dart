import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class MetadataImageStorageService {
  MetadataImageStorageService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const _defaultBucket = 'diary_images';

  String get _bucketName {
    const configured = String.fromEnvironment('SUPABASE_STORAGE_BUCKET');
    if (configured.isEmpty) {
      return _defaultBucket;
    }
    return configured;
  }

  Future<String> uploadImageBytes({
    required Uint8List bytes,
    required String originalFileName,
  }) async {
    final extension = p.extension(originalFileName).replaceFirst('.', '');
    final random = Random();
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(100000)}.${extension.isEmpty ? 'jpg' : extension}';
    final path = 'uploads/$fileName';

    try {
      await _client.storage
          .from(_bucketName)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: _contentTypeFromExtension(extension),
            ),
          );
    } on StorageException catch (e) {
// 💡 진짜 에러 메시지를 콘솔에 출력하도록 임시 추가합니다.
      print('🔥 진짜 Supabase 에러 내용: ${e.message}');
      print('🔥 진짜 Supabase 상태 코드: ${e.statusCode}');

      if (e.statusCode == '404' || e.statusCode == 404) {
        throw Exception('Supabase Storage 버킷 관련 에러 발생! \n상세 내용: ${e.message}');
      }
      rethrow;    }

    return _client.storage.from(_bucketName).getPublicUrl(path);
  }

  String _contentTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }
}
