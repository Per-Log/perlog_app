import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/widgets/bottom_button.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  static const int _selectedDay = 15;
  static const int _startOffset = 2; // 2025-01-01 is Wednesday with Monday as start.
  static const int _daysInMonth = 31;

  @override
  Widget build(BuildContext context) {
    final calendarCells = _buildCalendarCells();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                8,
                AppSpacing.horizontal,
                0,
              ),
              child: TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.mainFont,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  '이전',
                  style: AppTextStyles.body16Medium.copyWith(
                    color: AppColors.mainFont,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                4,
                AppSpacing.horizontal,
                0,
              ),
              child: Row(
                children: [
                  Text(
                    '원하는 날짜를 선택해주세요.',
                    style: AppTextStyles.body16.copyWith(
                      color: AppColors.mainFont,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.help_outline,
                    size: 16,
                    color: AppColors.subFont,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                6,
                AppSpacing.horizontal,
                0,
              ),
              child: Text(
                '2025년 01월 15일 목요일',
                style: AppTextStyles.body20Medium.copyWith(
                  color: AppColors.mainFont,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontal,
                ),
                child: Column(
                  children: [
                    _MonthHeader(
                      monthLabel: '2025년 01월',
                      onPrevious: () {},
                      onNext: () {},
                    ),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 10),
                    GridView.builder(
                      itemCount: calendarCells.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 4,
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
            Padding(
              padding: AppSpacing.bottomButtonPadding(context),
              child: BottomButton(
                text: '날짜 설정 완료',
                onPressed: () {
                  context.go('${Routes.metadata}/${Routes.imageUpload}');
                },
                enabled: true,
                backgroundColor: AppColors.subBackground,
                borderColor: AppColors.subBackground,
                textColor: AppColors.mainFont,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
  const _CalendarDay({
    required this.day,
    required this.isSelected,
  });

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
          style: AppTextStyles.body14.copyWith(
            color: AppColors.mainFont,
          ),
        ),
      ),
    );
  }
}