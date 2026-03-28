import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/models/notification_period.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/utils/image_uploader.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/domain/onboarding/onboarding_service.dart';
import 'package:perlog/domain/lock/lock_service.dart';
import 'package:perlog/features/onboarding/widgets/lock_setting_section.dart';
import 'package:perlog/features/onboarding/widgets/notification_setting_section.dart';
import 'package:perlog/features/onboarding/widgets/profile_image_picker.dart';

class OnboardingProfilePage extends StatefulWidget {
  const OnboardingProfilePage({super.key});

  @override
  State<OnboardingProfilePage> createState() =>
      _OnboardingProfilePageState();
}

class _OnboardingProfilePageState extends State<OnboardingProfilePage> {
  final _nicknameController = TextEditingController();
  final _focusNode = FocusNode();

  final _imageUploader = ImageUploader();

  Uint8List? _profilePreviewBytes;
  String? _profileImageUrl;
  bool _isUploading = false;

  bool notificationEnabled = true;
  bool lockEnabled = false;
  bool isPinSet = false;

  NotificationPeriod _period = NotificationPeriod.threeDays;

  // 완료 조건
  bool get isCompleted {
    final hasNickname = _nicknameController.text.trim().isNotEmpty;
    final lockCondition = !lockEnabled || isPinSet;
    return hasNickname && lockCondition;
  }

  // 프로필 이미지 업로드
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

  // PIN 설정
  Future<void> _handleSetPin() async {
    final result =
        await context.push('${Routes.onboarding}/${Routes.pinSet}');

    if (!mounted) return;

    if (result == true) {
      setState(() {
        isPinSet = true;
      });
    }
  }

  // 잠금 토글
  Future<void> _handleLockToggle() async {
    if (lockEnabled) {
      setState(() {
        lockEnabled = false;
      });
      return;
    }

    if (!isPinSet) {
      final result =
          await context.push('${Routes.onboarding}/${Routes.pinSet}');

      if (!mounted) return;

      if (result == true) {
        setState(() {
          isPinSet = true;
          lockEnabled = true;
        });
      }
      return;
    }

    setState(() {
      lockEnabled = true;
    });
  }

  // 온보딩 완료
  Future<void> _handleSubmit() async {
    if (!isCompleted) return;

    await OnboardingService.completeOnboarding(
      nickname: _nicknameController.text.trim(),
      notificationEnabled: notificationEnabled,
      period: _period,
      profileImageUrl: _profileImageUrl,
    );

    await LockService.setLockEnabled(lockEnabled);

    if (!mounted) return;
    context.go(Routes.home);
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
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen(context),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // 프로필 이미지
              ProfileImagePicker(
                onTap: _isUploading ? null : _handleProfileImageUpload,
                imageProvider: _profilePreviewBytes != null
                    ? MemoryImage(_profilePreviewBytes!)
                    : null,
                isUploading: _isUploading,
              ),

              SizedBox(height: AppSpacing.large(context)),

              // 닉네임 입력
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
                      onChanged: (_) => setState(() {}),
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
                        filled: true,
                        fillColor: isCompleted
                            ? AppColors.subBackground
                            : Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isCompleted
                                ? Colors.transparent
                                : AppColors.subFont,
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

              SizedBox(height: AppSpacing.large(context)),

              // 알림 설정
              NotificationSettingSection(
                enabled: notificationEnabled,
                period: _period,
                onToggle: () {
                  setState(() {
                    notificationEnabled = !notificationEnabled;
                  });
                },
                onChangePeriod: (value) {
                  setState(() {
                    _period = value;
                  });
                },
              ),

              SizedBox(height: AppSpacing.medium(context)),

              // 잠금 설정
              LockSettingSection(
                enabled: lockEnabled,
                isPinSet: isPinSet,
                onToggle: _handleLockToggle,
                onSetPin: _handleSetPin,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: AppSpacing.bottomButtonPadding(context),
        child: BottomButton(
          text: '시작하기',
          enabled: isCompleted,
          onPressed: _handleSubmit,
          backgroundColor: isCompleted
              ? AppColors.subBackground
              : AppColors.background,
          borderColor: isCompleted
              ? Colors.transparent
              : AppColors.subFont,
          textColor: AppColors.mainFont,
          textStyle: AppTextStyles.body20Medium,
        ),
      ),
    );
  }
}