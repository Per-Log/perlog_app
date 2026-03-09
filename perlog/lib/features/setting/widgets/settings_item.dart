import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: AppColors.paleBackground,
        highlightColor: AppColors.paleBackground,
        onTap: onTap ?? () {},
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.small(context) + 5),
          child: Text(
            title,
            style: AppTextStyles.body20.copyWith(
              color: AppColors.mainFont,
            ),
          ),
        ),
      ),
    );
  }
}