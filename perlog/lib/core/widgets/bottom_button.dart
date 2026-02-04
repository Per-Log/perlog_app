import 'package:flutter/material.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  final Color backgroundColor;
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
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    final height = AppSpacing.bottomButtonHeight(context);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: enabled ? onPressed : null,
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(backgroundColor),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(height / 2),
                  side: BorderSide(color: borderColor),
                ),
              ),
            ),
            child: Text(
              text,
              style: (textStyle ?? AppTextStyles.body18SemiBold).copyWith(
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
