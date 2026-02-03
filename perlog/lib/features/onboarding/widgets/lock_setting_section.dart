import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/features/onboarding/widgets/profile_header.dart';

class LockSettingSection extends StatelessWidget {
  final bool enabled;
  final bool isPinSet;
  final VoidCallback onToggle;
  final VoidCallback onSetPin;

  const LockSettingSection({
    super.key,
    required this.enabled,
    required this.isPinSet,
    required this.onToggle,
    required this.onSetPin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ProfileHeader(
            title: '잠금 설정',
            checked: enabled,
            message: '잠금 설정으로 나만의 기록을 안전하게 지킬 수 있어요.',
            onToggle: onToggle,
          ),
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: enabled
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 20 + 20 + AppSpacing.small(context),
                    top: AppSpacing.small(context),
                  ),
                  child: _LockSettingBody(
                    isPinSet: isPinSet,
                    onSetPin: onSetPin,
                  ),
                )
              : SizedBox(height: AppSpacing.medium(context)),
        ),
      ],
    );
  }
}

class _LockSettingBody extends StatelessWidget {
  final bool isPinSet;
  final VoidCallback onSetPin;

  const _LockSettingBody({
    required this.isPinSet,
    required this.onSetPin,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPinSet) {
      return GestureDetector(
        onTap: onSetPin,
        child: Row(
          children: [
            Text(
              '비밀번호 설정하기',
              style: AppTextStyles.body20Medium
                  .copyWith(color: AppColors.mainFont),
            ),
            const SizedBox(width: 6),
            Image.asset(
              'assets/icons/right_arrow_circle.png',
              width: 18,
              height: 18,
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Text(
          '비밀번호 설정 완료',
          style: AppTextStyles.body20Medium
              .copyWith(color: AppColors.subFont),
        ),
        const SizedBox(width: 6),
        Icon(
          Icons.lock,
          size: 14,
          color: AppColors.subFont,
        ),
      ],
    );
  }
}
