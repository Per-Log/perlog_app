import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/features/onboarding/widgets/help_icon.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final bool checked;
  final VoidCallback onToggle;
  final String message;

  const ProfileHeader({
    super.key,
    required this.title,
    required this.checked,
    required this.onToggle,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.mainFont;

    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: color,
            size: 22,
          ),
          SizedBox(width: AppSpacing.small(context)),
          Text(
            title,
            style: AppTextStyles.body20Medium.copyWith(color: color),
          ),
          SizedBox(width: AppSpacing.small(context)),
          HelpIcon(textColor: color, message: message),
        ],
      ),
    );
  }
}
