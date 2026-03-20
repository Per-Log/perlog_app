import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/features/setting/widgets/settings_item.dart';

class SettingsItemData {
  final String title;
  final VoidCallback? onTap;

  const SettingsItemData({
    required this.title,
    this.onTap,
  });
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const SettingsSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body20Medium.copyWith(
              color: AppColors.mainFont,
            ),
          ),

          const SizedBox(height: 12),

          ...items.map((item) {
            if (item["widget"] != null) {
              return item["widget"] as Widget;
            }

            return SettingsItem(
              title: item["title"],
              onTap: item["onTap"],
            );
          }).toList(),
        ],
      ),
    );
  }
}