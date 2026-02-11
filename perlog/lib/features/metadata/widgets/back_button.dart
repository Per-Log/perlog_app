import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class MetadataBackButton extends StatelessWidget {
  const MetadataBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap ?? () => Navigator.of(context).maybePop(),
        child: Text(
          '이전',
          style: AppTextStyles.body16.copyWith(color: AppColors.subFont),
        ),
      ),
    );
  }
}
