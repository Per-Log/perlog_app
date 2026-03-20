import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/models/notification_period.dart';
import 'package:perlog/core/utils/image_uploader.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/onboarding/widgets/profile_image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {

  final _nicknameController = TextEditingController();
  final _focusNode = FocusNode();

  final _imageUploader = ImageUploader();

  Uint8List? _profilePreviewBytes;
  String? _profileImageUrl;
  bool _isUploading = false;

  bool notificationEnabled = true;
  bool lockEnabled = true;
  bool isPinSet = false;

  NotificationPeriod _period = NotificationPeriod.threeDays;

  Future<void> _handleProfileImageUpload() async {
    if (!mounted) return;

    setState(() => _isUploading = true);

    try {
      final result = await _imageUploader.pickAndUploadImage();
      if (!mounted || result == null) return;

      setState(() {
        _profilePreviewBytes = result.bytes;
        _profileImageUrl = result.publicUrl;
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
  void dispose() {
    _nicknameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          '내 정보 수정',
          style: AppTextStyles.body22.copyWith(
            color: AppColors.mainFont,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.mainFont,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen(context),
          child: Column(
            children: [

              const SizedBox(height: 40),

              /// 프로필 이미지
              ProfileImagePicker(
                onTap: _isUploading ? null : _handleProfileImageUpload,
                imageProvider: _profilePreviewBytes != null
                    ? MemoryImage(_profilePreviewBytes!)
                    : null,
                isUploading: _isUploading,
              ),

              SizedBox(height: AppSpacing.large(context)+10),

              /// 별명
              Row(
                children: [

                  const SizedBox(width: 20),

                  Text(
                    '별명',
                    style: AppTextStyles.body20Medium.copyWith(
                      color: AppColors.mainFont,
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: TextField(
                      controller: _nicknameController,
                      focusNode: _focusNode,
                      textAlignVertical: TextAlignVertical.center,
                      style: AppTextStyles.body18SemiBold.copyWith(
                        color: AppColors.mainFont,
                      ),

                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.subFont,
                            width: 1.5,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.subFont,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: AppSpacing.bottomButtonPadding(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 회원 탈퇴
            BottomButton(
              text: '회원 탈퇴',
              enabled: true,
              onPressed: () {
                // TODO: 탈퇴 로직
              },
              backgroundColor: AppColors.background,
              borderColor: AppColors.subFont,
              textColor: AppColors.subFont,
              // borderColor: const Color(0xFF8C8C8C), 
              // textColor: const Color(0xFF8C8C8C),
              textStyle: AppTextStyles.body20Medium,
            ),

            const SizedBox(height: 10),

            /// 수정 완료
            BottomButton(
              text: '수정 완료',
              enabled: true,
              onPressed: () {
                context.pop();
              },
              backgroundColor: AppColors.paleBackground,
              borderColor: AppColors.subFont,
              textColor: AppColors.mainFont,
              textStyle: AppTextStyles.body20Medium,
            ),

          ],
        ),
      ),
    );
  }
}