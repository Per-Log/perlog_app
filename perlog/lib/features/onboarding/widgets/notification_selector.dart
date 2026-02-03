import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/models/notification_period.dart';

class NotificationPeriodSelector extends StatelessWidget {
  final NotificationPeriod value;
  final VoidCallback onTap;

  const NotificationPeriodSelector({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const arrowSize = 40.0; 
    const selectorHeight = 40.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: selectorHeight,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.subBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Center(
                child: Text(
                  value.label,
                  style: AppTextStyles.body18SemiBold.copyWith(
                    color: AppColors.mainFont,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: arrowSize,
              child: Icon(
                Icons.arrow_drop_down,
                size: arrowSize,
                color: AppColors.subFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
