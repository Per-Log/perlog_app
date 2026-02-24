import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/utils/image_uploader.dart';

import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'package:perlog/features/metadata/widgets/upload_preview.dart';

class ImageUploadEdit extends StatefulWidget {
  const ImageUploadEdit({super.key, this.args});
  final MetadataImageData? args;

  @override
  State<ImageUploadEdit> createState() => _ImageUploadEditState();
}

class _ImageUploadEditState extends State<ImageUploadEdit> {
 final _imageUploader = ImageUploader();

  bool _isUploading = false;
  String? _uploadedImageUrl;
  Uint8List? _previewBytes;
  double? _imageWidth;
  double? _imageHeight;

  Future<void> _handleImageUpload() async {
  if (!mounted) return;

  setState(() => _isUploading = true);

  try {
    final result = await _imageUploader.pickAndUploadImage();

    if (!mounted || result == null) return;

    setState(() {
      _previewBytes = result.bytes;
      _imageWidth = result.width;
      _imageHeight = result.height;
      _uploadedImageUrl = result.publicUrl;
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
  } finally {
    if (mounted) {
      setState(() => _isUploading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);
    final isImageUploaded = _uploadedImageUrl != null;
    final selectedDate = widget.args?.selectedDate ?? DateTime.now();

    // 활성화 여부에 따른 상태값 (업로드가 완료되었거나 필요한 조건을 충족했을 때 true로 변경하시면 됩니다)
    // 현재 코드 기획상 에딧 페이지에서는 버튼이 항상 비활성 상태이지만, 추후 활성화될 경우를 대비해 변수로 뺐습니다.
    // final isButtonEnabled = false;

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
                      onTap: () =>
                          context.go('${Routes.metadata}/${Routes.calendar}'),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Center(
                          child: SizedBox(
                            width: 393,
                            height: double.infinity, // 세로만 꽉 채우기
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.subBackground,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _isUploading
                                  ? null
                                  : _handleImageUpload,
                              child:
                                  _previewBytes != null &&
                                      _imageWidth != null &&
                                      _imageHeight != null
                                  ? UploadPreview(
                                      imageProvider: MemoryImage(
                                        _previewBytes!,
                                      ),
                                      imageWidth: _imageWidth!,
                                      imageHeight: _imageHeight!,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              .copyWith(
                                                color: AppColors.subFont,
                                              ),
                                        ),
                                      ],
                                    ),
                            ),
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
                onPressed: isImageUploaded
                    ? () => context.go(
                        '${Routes.metadata}/${Routes.ocrLoading}',
                        // 💡 날짜 데이터 유지
                        extra: MetadataImageData(
                          selectedDate: selectedDate,
                          publicUrl: _uploadedImageUrl,
                          width: _imageWidth,
                          height: _imageHeight,
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
