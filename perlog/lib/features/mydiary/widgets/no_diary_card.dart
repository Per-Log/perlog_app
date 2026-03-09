import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class NoDiaryCard extends StatelessWidget {
  final DateTime selectedDate;

  const NoDiaryCard({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'yyyy년 M월 d일 E요일',
      'ko_KR',
    ).format(selectedDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendar,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.selectedBackground,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: AppTextStyles.body18.copyWith(
              color: AppColors.mainFont,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '등록된 일기가 없어요 :(',
            style: AppTextStyles.body14.copyWith(
              color: AppColors.mainFont,
            ),
          ),
        ],
      ),
    );
  }
}