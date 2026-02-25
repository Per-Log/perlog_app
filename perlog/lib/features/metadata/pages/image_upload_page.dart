import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/utils/image_uploader.dart';
import 'package:perlog/core/widgets/bottom_button.dart';

import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/features/metadata/widgets/upload_preview.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key, this.args});
  final MetadataImageData? args;

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
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

    final selectedDate =
        widget.args?.selectedDate ?? DateTime.now();

    final formattedDate = DateFormat(
      'yyyy년 MM월 dd일 EEEE',
      'ko_KR',
    ).format(selectedDate);

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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    MetadataBackButton(
                      onTap: () => context.go(
                        '${Routes.metadata}/${Routes.calendar}',
                      ),
                    ),

                    SizedBox(
                        height: AppSpacing.large(context)),

                    Text(
                      '퍼로그님, 오늘 하루는 어떠셨나요?',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),

                    SizedBox(
                        height: AppSpacing.small(context)),

                    Text(
                      formattedDate,
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),

                    SizedBox(
                        height: AppSpacing.vertical),

                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 35),
                        child: Center(
                          child: SizedBox(
                            width: 393,
                            height: double.infinity,
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                     AppColors.subBackground,
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(10),
                                ),
                                side: isImageUploaded
                                    ? BorderSide(
                                        color: AppColors
                                            .mainFont,
                                        width: 1,
                                      )
                                    : BorderSide.none,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: _isUploading
                                  ? null
                                  : _handleImageUpload,
                              child: _previewBytes != null &&
                                      _imageWidth != null &&
                                      _imageHeight !=
                                          null
                                  ? UploadPreview(
                                      imageProvider:
                                          MemoryImage(
                                              _previewBytes!),
                                      imageWidth:
                                          _imageWidth!,
                                      imageHeight:
                                          _imageHeight!,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Icon(
                                          _isUploading
                                              ? Icons.sync
                                              : Icons
                                                  .camera_alt_outlined,
                                          size: 48,
                                          color: AppColors
                                              .subFont,
                                        ),
                                        const SizedBox(
                                            height: 12),
                                        Text(
                                          _isUploading
                                              ? '업로드 중...'
                                              : '이미지 업로드',
                                          style:
                                              AppTextStyles
                                                  .body20Medium
                                                  .copyWith(
                                            color: AppColors
                                                .subFont,
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: AppSpacing.bottomButtonPadding(context),
        child: BottomButton(
          text: '다음으로',
          onPressed: () {
            if (!isImageUploaded) return;

            context.go(
              '${Routes.metadata}/${Routes.ocrLoading}',
              extra: MetadataImageData(
                selectedDate: selectedDate,
                publicUrl: _uploadedImageUrl,
                width: _imageWidth,
                height: _imageHeight,
              ),
            );
          },
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
    );
  }
}