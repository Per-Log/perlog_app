import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';

class CalendarContent extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final double rowHeight;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final Function(PageController) onCalendarCreated;
  final List<String> weekdayLabels;

  const CalendarContent({
    super.key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.selectedDay,
    required this.rowHeight,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onCalendarCreated,
    required this.weekdayLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendar,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body12.copyWith(
                        color: AppColors.subFont,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: AppSpacing.small(context)),
          TableCalendar(
            locale: 'ko_KR',
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: focusedDay,
            selectedDayPredicate: (day) =>
                isSameDay(selectedDay, day),
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
            onCalendarCreated: onCalendarCreated,
            headerVisible: false,
            daysOfWeekVisible: false,
            calendarFormat: CalendarFormat.month,
            availableGestures:
                AvailableGestures.horizontalSwipe,
            rowHeight: rowHeight,
            calendarStyle: CalendarStyle(
              defaultTextStyle: AppTextStyles.body12.copyWith(
                color: const Color(0xFFB28A5F),
                fontWeight: FontWeight.w600,
              ),
              outsideTextStyle: AppTextStyles.body12.copyWith(
                color: const Color(0xFFc2c0be),
                fontWeight: FontWeight.w600,
              ),
              weekendTextStyle: AppTextStyles.body12.copyWith(
                color: const Color(0xFFB28A5F),
                fontWeight: FontWeight.w600,
              ),
              todayTextStyle: AppTextStyles.body12.copyWith(
                color: const Color(0xFFB28A5F),
                fontWeight: FontWeight.w600,
              ),
              todayDecoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
                border: Border.all(
                  color: AppColors.mainFont,
                  width: 1.5,
                ),
              ),
              selectedTextStyle: AppTextStyles.body12.copyWith(
                color: AppColors.mainFont,
                fontWeight: FontWeight.w600,
              ),
              cellMargin:
                  const EdgeInsets.symmetric(vertical: 6),
            ),
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, day, focusedDay) {
                return Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                      border: Border.all(
                        color: AppColors.mainFont,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: AppTextStyles.body12.copyWith(
                        color: AppColors.mainFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}