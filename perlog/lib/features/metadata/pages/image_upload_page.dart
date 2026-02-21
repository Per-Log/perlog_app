import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'package:perlog/features/metadata/services/metadata_image_storage_service.dart';
import 'package:perlog/features/metadata/widgets/upload_preview.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final _picker = ImagePicker();
  final _storageService = MetadataImageStorageService();

  bool _isUploading = false;
  String? _uploadedImageUrl;
  Uint8List? _previewBytes;
  double? _imageWidth;
  double? _imageHeight;

  Future<void> _handleImageUpload() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted || pickedFile == null) {
      return;
    }

    setState(() => _isUploading = true);

    final bytes = await pickedFile.readAsBytes();
    final imageSize = await _readImageSize(bytes);

    try {
      final uploadedImageUrl = await _storageService.uploadImageBytes(
        bytes: bytes,
        originalFileName: pickedFile.name,
      );
      if (!mounted) return;

      setState(() {
        _previewBytes = bytes;
        _imageWidth = imageSize.$1;
        _imageHeight = imageSize.$2;
        _uploadedImageUrl = uploadedImageUrl;
      });

      context.go(
        '${Routes.metadata}/${Routes.imageUploadFinished}',
        extra: MetadataImageData(
          publicUrl: uploadedImageUrl,
          width: imageSize.$1,
          height: imageSize.$2,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<(double, double)> _readImageSize(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    return (image.width.toDouble(), image.height.toDouble());
  }
  
  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);
    final isImageUploaded = _uploadedImageUrl != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenPadding.left,
                  screenPadding.top,
                  screenPadding.right,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 기존에 있던 SizedBox(height: AppSpacing.vertical * 2) 제거됨
                    MetadataBackButton(
                      onTap: () =>
                          context.go('${Routes.metadata}/${Routes.calendar}'),
                    ),
                    SizedBox(height: AppSpacing.large(context)),
                    Text(
                      '퍼로그님, 오늘 하루는 어떠셨나요?',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    SizedBox(height: AppSpacing.small(context)),
                    Text(
                      '오늘은 2025년 1월 15일 목요일이에요.',
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    SizedBox(height: AppSpacing.vertical),

                    // 이미지 업로드 버튼
                    Center(
                      child: SizedBox(
                        width: 393,
                        height: 498,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isImageUploaded
                                ? const Color(0xFFE5D9C5)
                                : AppColors.subBackground,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: isImageUploaded
                                ? BorderSide(
                                    color: AppColors.mainFont,
                                    width: 1,
                                  )
                                : BorderSide.none,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: _isUploading ? null : _handleImageUpload,
                          child:
                              _previewBytes != null &&
                                  _imageWidth != null &&
                                  _imageHeight != null
                              ? UploadPreview(
                                  imageProvider: MemoryImage(_previewBytes!),
                                  imageWidth: _imageWidth!,
                                  imageHeight: _imageHeight!,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _isUploading
                                          ? Icons.sync
                                          : Icons.camera_alt_outlined,
                                      size: 48,
                                      color: AppColors.subFont,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _isUploading ? '업로드 중...' : '이미지 업로드',
                                      style: AppTextStyles.body20Medium
                                          .copyWith(color: AppColors.subFont),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expanded 바깥으로 분리된 BottomButton (캘린더 페이지와 동일한 위치/색상)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                0,
                AppSpacing.horizontal,
                screenPadding.bottom,
              ),
              child: BottomButton(
                text: '다음으로',
                onPressed: isImageUploaded
                    ? () => context.go(
                        '${Routes.metadata}/${Routes.ocrLoading}',
                        extra: MetadataImageData(
                          publicUrl: _uploadedImageUrl!,
                          width: _imageWidth!,
                          height: _imageHeight!,
                        ),
                      )
                    : () {},
                enabled: isImageUploaded,
                backgroundColor: isImageUploaded
                    ? AppColors.subBackground
                    : AppColors.background,
                borderColor: isImageUploaded
                    ? AppColors.subBackground
                    : AppColors.subFont,
                textColor: isImageUploaded
                    ? AppColors.mainFont
                    : AppColors.subFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
