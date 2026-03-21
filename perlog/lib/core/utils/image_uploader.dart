import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:perlog/features/metadata/services/metadata_image_storage_service.dart';

class ImageUploader {
  static const double minSharpnessVariance = 100.0;

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
    final sharpnessVariance = _calculateLaplacianVariance(bytes);

    final uploadedImageUrl = await _storageService.uploadImageBytes(
      bytes: bytes,
      originalFileName: pickedFile.name,
    );

    return ImageUploadResult(
      publicUrl: uploadedImageUrl,
      bytes: bytes,
      width: imageSize.$1,
      height: imageSize.$2,
      sharpnessVariance: sharpnessVariance,
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

  double _calculateLaplacianVariance(Uint8List bytes) {
    final decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) {
      return double.infinity;
    }

    final grayscale = img.grayscale(decodedImage);
    if (grayscale.width < 3 || grayscale.height < 3) {
      return double.infinity;
    }

    final values = <double>[];

    for (var y = 1; y < grayscale.height - 1; y++) {
      for (var x = 1; x < grayscale.width - 1; x++) {
        final center = grayscale.getPixel(x, y).r.toDouble();
        final top = grayscale.getPixel(x, y - 1).r.toDouble();
        final bottom = grayscale.getPixel(x, y + 1).r.toDouble();
        final left = grayscale.getPixel(x - 1, y).r.toDouble();
        final right = grayscale.getPixel(x + 1, y).r.toDouble();

        final laplacianValue = (4 * center) - top - bottom - left - right;
        values.add(laplacianValue);
      }
    }

    if (values.isEmpty) {
      return double.infinity;
    }

    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance =
        values.fold<double>(0, (sum, value) => sum + pow(value - mean, 2)) /
        values.length;

    return variance;
  }
}

class ImageUploadResult {
  final String publicUrl;
  final Uint8List bytes;
  final double width;
  final double height;
  final double sharpnessVariance;

  const ImageUploadResult({
    required this.publicUrl,
    required this.bytes,
    required this.width,
    required this.height,
    required this.sharpnessVariance,
  });
  
  bool get isBlurry => sharpnessVariance < ImageUploader.minSharpnessVariance;
}