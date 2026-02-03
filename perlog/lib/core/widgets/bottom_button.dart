import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color borderColor;
  final Color textColor;

  final TextStyle? textStyle;

  const BottomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.enabled,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.disabledBackgroundColor = AppColors.background,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    final height = AppSpacing.bottomButtonHeight(context);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: enabled ? backgroundColor : disabledBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
            side: BorderSide(color: enabled ? borderColor : Colors.transparent),
          ),
        ),
        child: Text(
          text,
          style: (textStyle ?? AppTextStyles.body18SemiBold).copyWith(
            color: enabled ? textColor : AppColors.subFont,
          ),
        ),
      ),
    );
  }
}
