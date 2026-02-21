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

class ImageUploadEdit extends StatefulWidget {
  const ImageUploadEdit({super.key});

  @override
  State<ImageUploadEdit> createState() => _ImageUploadEditState();
}

class _ImageUploadEditState extends State<ImageUploadEdit> {
  final _picker = ImagePicker();
  final _storageService = MetadataImageStorageService();

  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
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
                    SizedBox(height: AppSpacing.vertical * 2),
                    MetadataBackButton(
                      onTap: () => context.go(
                        '${Routes.metadata}/${Routes.imageUpload}',
                      ),
                    ),
                    SizedBox(height: AppSpacing.small(context)),
                    Text(
                      '글씨가 잘 보이지 않아요.',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),

                    ///SizedBox(height: AppSpacing.small(context)),
                    Text(
                      '조금 더 밝은 곳에서,',
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    Text(
                      '종이가 화면에 가득 차도록 다시 찍어볼까요?',
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    SizedBox(height: AppSpacing.vertical),
                    Center(
                      child: SizedBox(
                        width: 393,
                        height: 498,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.subBackground,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _isUploading ? null : _pickAndUploadImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isUploading ? '업로드 중...' : '이미지 업로드',
                                style: AppTextStyles.body20Medium.copyWith(
                                  color: AppColors.subFont,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _isUploading
                                    ? Icons.sync
                                    : Icons.camera_alt_outlined,
                                size: 28,
                                color: AppColors.subFont,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 27),
                    BottomButton(
                      text: '다음으로',
                      onPressed: () {},
                      enabled: false,
                      backgroundColor: AppColors.background,
                      borderColor: AppColors.subFont,
                      textColor: AppColors.subFont,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
