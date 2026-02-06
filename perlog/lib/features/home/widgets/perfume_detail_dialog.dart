import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'perfume_icon.dart';

class PerfumeDetailDialog extends StatelessWidget {
  final Color color;

  const PerfumeDetailDialog({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.2), // TODO: mediaquery
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: const BoxConstraints(minHeight: 300, maxHeight: 300),
          padding: AppSpacing.card,
          decoration: BoxDecoration(
            color: AppColors.perfumeDetails,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PerfumeIcon(color: color, size: 52),
                  const SizedBox(width: 12),
                  Text(
                    '#레몬향   #과일향',
                    style: AppTextStyles.body18SemiBold.copyWith(color: AppColors.mainFont)
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.medium(context)+8), 

              Text(
                '여기에는 향에 대한 설명이 나와요.\n'
                '그 향은 어떤 향인지, 어떤 감정을 담는지\n'
                '이곳에서 알아봐요.',
                style: AppTextStyles.body14.copyWith(color: AppColors.mainFont),
              ),

              Spacer(),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.subBackground,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '닫기',
                      style: AppTextStyles.body16.copyWith(color: AppColors.mainFont)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
