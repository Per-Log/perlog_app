import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetadataImageUploadService {
  MetadataImageUploadService._();

  static const _bucketName = 'metadata-images';

  static Future<String> uploadImageAndGetUrl(XFile image) async {
    final client = Supabase.instance.client;
    final imageBytes = await image.readAsBytes();
    final extension = image.name.contains('.')
        ? image.name.split('.').last.toLowerCase()
        : 'jpg';

    final random = Random();
    final objectPath =
        'uploads/${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(100000)}.$extension';

    await client.storage
        .from(_bucketName)
        .uploadBinary(
          objectPath,
          imageBytes,
          fileOptions: FileOptions(
            contentType: 'image/$extension',
            upsert: false,
          ),
        );

    return client.storage.from(_bucketName).getPublicUrl(objectPath);
  }
}
