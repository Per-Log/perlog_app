import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/models/notification_period.dart';

void showNotificationPeriodSheet({
  required BuildContext context,
  required NotificationPeriod current,
  required ValueChanged<NotificationPeriod> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: AppSpacing.screen(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: NotificationPeriod.values.map((period) {
            final selected = period == current;

            return ListTile(
              title: Text(
                period.label,
                style: AppTextStyles.body18SemiBold.copyWith(
                  color: selected
                      ? AppColors.mainFont
                      : AppColors.subFont,
                ),
              ),
              trailing: selected
                  ? Icon(Icons.check, color: AppColors.mainFont)
                  : null,
              onTap: () {
                onSelected(period);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}
