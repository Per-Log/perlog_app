import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class CalendarWarningPopup extends StatelessWidget {
  const CalendarWarningPopup({
    super.key,
    required this.primaryMessage,
    required this.onClose,
    this.secondaryMessage = '다시 선택해주세요.',
    this.messageSpacing = 15,
  });

  final String primaryMessage;
  final String secondaryMessage;
  final double messageSpacing;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5F4),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.error_outline,
                color: AppColors.mainFont,
                size: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              primaryMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.body20Medium.copyWith(
                color: AppColors.mainFont,
                fontSize: 18,
              ),
            ),
            SizedBox(height: messageSpacing),
            Text(
              secondaryMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.body20Medium.copyWith(
                color: AppColors.mainFont,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 132,
              height: 44,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.subBackground,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  '닫기',
                  style: AppTextStyles.body20Medium.copyWith(
                    color: AppColors.mainFont,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
