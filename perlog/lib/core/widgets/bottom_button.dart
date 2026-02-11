import 'package:flutter/material.dart';
import '../constants/text_styles.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final TextStyle? textStyle;

  final Widget? trailing; // 우측 아이콘

  const BottomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.textStyle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: (textStyle ??
                      AppTextStyles.body18SemiBold)
                  .copyWith(color: textColor),
            ),

            if (trailing != null) ...[
              const SizedBox(width: 20),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
