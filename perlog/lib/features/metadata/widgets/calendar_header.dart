import 'package:flutter/material.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';

class CalendarHeader extends StatelessWidget {
  final String selectedLabel;

  const CalendarHeader({
    super.key,
    required this.selectedLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSpacing.small(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.medium(context) + 10),
          Text(
            '원하는 날짜를 선택해주세요.',
            style: AppTextStyles.body16.copyWith(
              color: AppColors.mainFont,
            ),
          ),
          SizedBox(height: AppSpacing.small(context)),
          Text(
            selectedLabel,
            style: AppTextStyles.body20Medium.copyWith(
              color: AppColors.mainFont,
            ),
          ),
        ],
      ),
    );
  }
}