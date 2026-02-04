import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  static const int _selectedDay = 15;
  static const int _startOffset = 2; // 2025-01-01 is Wednesday with Monday as start.
  static const int _daysInMonth = 31;

  @override
  Widget build(BuildContext context) {
    final calendarCells = _buildCalendarCells();
    final screenPadding = AppSpacing.screen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenPadding.left,
                  screenPadding.top,
                  screenPadding.right,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MetadataBackButton(),
                    SizedBox(height: AppSpacing.section(context)),
                    Row(
                      children: [
                        Text(
                          '원하는 날짜를 선택해주세요.',
                          style: AppTextStyles.body16.copyWith(
                            color: AppColors.mainFont,
                          ),
                        ),
                        SizedBox(width: AppSpacing.small(context) / 2),
                        Icon(
                          Icons.help_outline,
                          size: 16,
                          color: AppColors.subFont,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.small(context)),
                    Text(
                      '2025년 01월 15일 목요일',
                      style: AppTextStyles.body20Medium.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    SizedBox(height: AppSpacing.medium(context)),
                    _MonthHeader(
                      monthLabel: '2025년 01월',
                      onPrevious: () {},
                      onNext: () {},
                    ),
                    SizedBox(height: AppSpacing.small(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _weekdayLabels
                          .map(
                            (label) => Expanded(
                              child: Text(
                                label,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body14.copyWith(
                                  color: AppColors.subFont,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: AppSpacing.small(context)),
                    GridView.builder(
                      itemCount: calendarCells.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: AppSpacing.cardPadding / 2,
                        crossAxisSpacing: AppSpacing.cardPadding / 4,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final day = calendarCells[index];
                        return _CalendarDay(
                          day: day,
                          isSelected: day == _selectedDay,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int?> _buildCalendarCells() {
    final cells = <int?>[
      ...List<int?>.filled(_startOffset, null),
      ...List<int?>.generate(_daysInMonth, (index) => index + 1),
    ];

    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return cells;
  }
}

const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.monthLabel,
    required this.onPrevious,
    required this.onNext,
  });

  final String monthLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding / 2,
        vertical: AppSpacing.cardPadding / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.subBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
            color: AppColors.mainFont,
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            monthLabel,
            style: AppTextStyles.body16Medium.copyWith(
              color: AppColors.mainFont,
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
            color: AppColors.mainFont,
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({required this.day, required this.isSelected});

  final int? day;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (day == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: AppColors.mainFont, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: AppTextStyles.body14.copyWith(color: AppColors.mainFont),
        ),
      ),
    );
  }
}
