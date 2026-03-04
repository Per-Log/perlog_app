import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class MonthHeader extends StatelessWidget {
  final String monthLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MonthHeader({
    super.key,
    required this.monthLabel,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.subBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPrevious,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            icon: Image.asset(
              'assets/icons/left_arrow.png',
              width: 25,
              height: 25,
            ),
          ),
          Text(
            monthLabel,
            style: AppTextStyles.body18.copyWith(
              color: AppColors.mainFont,
              fontSize: 20,
            ),
          ),
          IconButton(
            onPressed: onNext,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            icon: Image.asset(
              'assets/icons/right_arrow.png',
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }
}