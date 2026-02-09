import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:table_calendar/table_calendar.dart';
 
class Calendar extends StatefulWidget  {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  static final DateTime _firstDay = DateTime(2000, 1, 1);
  static final DateTime _lastDay = DateTime(2100, 12, 31);

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  PageController? _pageController;

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _handlePageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _handlePreviousMonth() {
    _pageController?.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _handleNextMonth() {
    _pageController?.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);
    final selectedDay = _selectedDay ?? _focusedDay;
    final selectedLabel = DateFormat(
      'yyyy년 MM월 dd일 EEEE',
      'ko_KR',
    ).format(selectedDay);
    final monthLabel = DateFormat('yyyy년 MM월', 'ko_KR').format(_focusedDay);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
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
                      SizedBox(height: AppSpacing.large(context)),
                      Text(
                        '원하는 날짜를 선택해주세요.',
                        style: AppTextStyles.body16.copyWith(
                          color: AppColors.mainFont,
                        ),
                      ),
                      SizedBox(height: AppSpacing.medium(context)),
                      Text(
                        selectedLabel,
                        style: AppTextStyles.body20Medium.copyWith(
                          color: AppColors.mainFont,
                        ),
                      ),
                      SizedBox(height: AppSpacing.medium(context)),
                      _MonthHeader(
                        monthLabel: monthLabel,
                        onPrevious: _handlePreviousMonth,
                        onNext: _handleNextMonth,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.cardPadding / 2,
                          vertical: AppSpacing.cardPadding / 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.subBackground,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TableCalendar(
                          locale: 'ko_KR',
                          firstDay: _firstDay,
                          lastDay: _lastDay,
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: _handleDaySelected,
                          onPageChanged: _handlePageChanged,
                          onCalendarCreated: (controller) {
                            _pageController = controller;
                          },
                          headerVisible: false,
                          daysOfWeekVisible: false,
                          calendarFormat: CalendarFormat.month,
                          availableGestures: AvailableGestures.horizontalSwipe,
                          rowHeight: 42,
                          calendarStyle: CalendarStyle(
                            defaultTextStyle: AppTextStyles.body14.copyWith(
                              color: AppColors.mainFont,
                            ),
                            weekendTextStyle: AppTextStyles.body14.copyWith(
                              color: AppColors.mainFont,
                            ),
                            todayTextStyle: AppTextStyles.body14.copyWith(
                              color: AppColors.mainFont,
                            ),
                            todayDecoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            selectedDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.mainFont,
                                width: 1.5,
                              ),
                            ),
                            selectedTextStyle: AppTextStyles.body14.copyWith(
                              color: AppColors.mainFont,
                            ),
                            cellMargin: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            dowTextFormatter: (date, _) {
                              return _weekdayLabels[date.weekday - 1];
                            },
                          ),
                        ),
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