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

    // 활성화 여부에 따른 상태값 (업로드가 완료되었거나 필요한 조건을 충족했을 때 true로 변경하시면 됩니다)
    // 현재 코드 기획상 에딧 페이지에서는 버튼이 항상 비활성 상태이지만, 추후 활성화될 경우를 대비해 변수로 뺐습니다.
    final isButtonEnabled = false;

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
                    // 이전 버튼 위 여백 제거
                    MetadataBackButton(
                      onTap: () => context.go(
                        '${Routes.metadata}/${Routes.imageUpload}',
                      ),
                    ),
                    SizedBox(height: AppSpacing.large(context)),
                    Text(
                      '글씨가 잘 보이지 않아요.',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
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
                  ],
                ),
              ),
            ),
            // 하단 버튼 분리 및 캘린더 색상 정책 반영
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                0,
                AppSpacing.horizontal,
                screenPadding.bottom,
              ),
              child: BottomButton(
                text: '다음으로',
                onPressed: () {},
                enabled: isButtonEnabled,
                backgroundColor: isButtonEnabled
                    ? AppColors.subBackground
                    : AppColors.background,
                borderColor: isButtonEnabled
                    ? AppColors.subBackground
                    : AppColors.subFont,
                textColor: isButtonEnabled
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
