import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/models/notification_period.dart';
import 'package:perlog/core/utils/image_uploader.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/domain/onboarding/onboarding_service.dart'; // ✅ Service import 추가
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
  bool _isSaving = false; // ✅ 저장 중 상태를 관리하는 변수 추가

  bool notificationEnabled = true;
  bool lockEnabled = true;
  bool isPinSet = false;

  NotificationPeriod _period = NotificationPeriod.threeDays;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile(); // ✅ 화면이 켜질 때 기존 정보 불러오기
  }

  // ✅ 기존 프로필 정보(별명, 사진) 불러오기
  Future<void> _loadCurrentProfile() async {
    final nickname = await OnboardingService.getNickname();
    final imageUrl = await OnboardingService.getProfileImageUrl();

    if (!mounted) return;

    setState(() {
      _nicknameController.text = nickname ?? '';
      _profileImageUrl = imageUrl;
    });
  }

  // 프로필 이미지 선택 및 업로드
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  // ✅ 수정 완료 로직
  Future<void> _handleSave() async {
    if (_isSaving) return;

    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('별명을 입력해주세요.')));
      return;
    }

    setState(() => _isSaving = true); // 로딩 시작

    try {
      // DB 및 로컬에 프로필 업데이트 요청
      await OnboardingService.updateProfile(
        nickname: nickname,
        profileImageUrl: _profileImageUrl,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로필이 성공적으로 수정되었습니다.')));
      context.pop(); // 성공 시 이전 화면으로 돌아가기
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('수정 실패: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false); // 로딩 종료
      }
    }
  }

  // ✅ 이미지를 화면에 띄우기 위한 헬퍼 메서드
  ImageProvider? get _imageProvider {
    if (_profilePreviewBytes != null) {
      // 1. 방금 갤러리에서 새로 고른 이미지가 있으면 그것을 보여줌
      return MemoryImage(_profilePreviewBytes!);
    }
    if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      // 2. 고른 게 없지만 기존에 저장해둔 사진 URL이 있으면 서버에서 불러와서 보여줌
      return NetworkImage(_profileImageUrl!);
    }
    // 3. 둘 다 없으면 기본 아이콘 표시
    return null;
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
        iconTheme: const IconThemeData(color: AppColors.mainFont),
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
                // ✅ 수정한 _imageProvider 적용
                imageProvider: _imageProvider,
                isUploading: _isUploading,
              ),

              SizedBox(height: AppSpacing.large(context) + 10),

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
              textStyle: AppTextStyles.body20Medium,
            ),

            const SizedBox(height: 10),

            /// 수정 완료
            BottomButton(
              text: _isSaving ? '저장 중...' : '수정 완료', // ✅ 로딩 텍스트 적용
              enabled: !_isSaving, // ✅ 저장 중일 때 버튼 비활성화로 중복 터치 방지
              onPressed: _handleSave, // ✅ 작성해둔 저장 로직 연결
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
