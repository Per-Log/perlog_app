import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class FontSelector extends StatelessWidget {
  final String selectedFont;
  final VoidCallback onTap;

  const FontSelector({
    super.key,
    required this.selectedFont,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.subBackground,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedFont,
                style: AppTextStyles.body16.copyWith(
                  color: AppColors.mainFont,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: AppColors.subFont,
            ),
          ],
        ),
      ),
    );
  }
}