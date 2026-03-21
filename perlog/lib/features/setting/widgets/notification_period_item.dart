import 'package:flutter/material.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/models/notification_period.dart';

class NotificationPeriodItem extends StatelessWidget {
  final NotificationPeriod period;
  final VoidCallback onTap;

  const NotificationPeriodItem({
    super.key,
    required this.period,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text("알림 주기", style: AppTextStyles.body14),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(period.label, style: AppTextStyles.body14),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}