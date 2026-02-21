import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/models/notification_period.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/onboarding/widgets/lock_setting_section.dart';
import 'package:perlog/features/onboarding/widgets/notification_setting_section.dart';
import 'package:perlog/features/onboarding/widgets/profile_image_picker.dart';

class OnboardingProfilePage extends StatefulWidget {
  const OnboardingProfilePage({super.key});

  @override
  State<OnboardingProfilePage> createState() => _OnboardingProfilePageState();
}

class _OnboardingProfilePageState extends State<OnboardingProfilePage> {
  final _nicknameController = TextEditingController();
  final _focusNode = FocusNode();

  bool get isCompleted => _nicknameController.text.trim().isNotEmpty;

  bool notificationEnabled = true;
  bool lockEnabled = true;
  bool isPinSet = false;

  NotificationPeriod _period = NotificationPeriod.threeDays;

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

              /// 프로필 이미지
              ProfileImagePicker(
                onTap: () {
                  // TODO: 이미지 선택 로직
                },
              ),

              SizedBox(height: AppSpacing.large(context)),

              /// 별명 입력
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

              /// 알림 설정
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

              /// 잠금 설정
              LockSettingSection(
                enabled: lockEnabled,
                isPinSet: isPinSet,
                onToggle: () {
                  setState(() {
                    lockEnabled = !lockEnabled;
                  });
                },
                onSetPin: () async {
                  await context.push('${Routes.onboarding}/${Routes.pinSet}');
                  setState(() {
                    isPinSet = true;
                  });
                },
              ),

              const Spacer(),

              /// 시작하기 버튼
              BottomButton(
                text: '시작하기',
                enabled: isCompleted,
                onPressed: () {
                  context.go(Routes.home);
                },
                backgroundColor:
                    isCompleted ? AppColors.subBackground : AppColors.background,
                borderColor:
                    isCompleted ? Colors.transparent : AppColors.subFont,
                textColor: AppColors.mainFont,
                textStyle: AppTextStyles.body20Medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
