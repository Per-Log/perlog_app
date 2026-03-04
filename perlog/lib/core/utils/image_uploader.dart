import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';
import 'package:perlog/features/metadata/services/metadata_image_storage_service.dart';

class ImageUploader {
  final ImagePicker _picker = ImagePicker();
  final MetadataImageStorageService _storageService =
      MetadataImageStorageService();

  Future<ImageUploadResult?> pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    final bytes = await pickedFile.readAsBytes();
    final imageSize = await _readImageSize(bytes);

    final uploadedImageUrl = await _storageService.uploadImageBytes(
      bytes: bytes,
      originalFileName: pickedFile.name,
    );

    return ImageUploadResult(
      publicUrl: uploadedImageUrl,
      bytes: bytes,
      width: imageSize.$1,
      height: imageSize.$2,
    );
  }

  Future<(double, double)> _readImageSize(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    return (
      image.width.toDouble(),
      image.height.toDouble(),
    );
  }
}

class ImageUploadResult {
  final String publicUrl;
  final Uint8List bytes;
  final double width;
  final double height;

  ImageUploadResult({
    required this.publicUrl,
    required this.bytes,
    required this.width,
    required this.height,
  });
}