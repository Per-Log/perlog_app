import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/features/metadata/widgets/calendar_warning_popup.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';

class Calendar extends StatefulWidget {
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

  static const String _pastLimitPrimaryMessage = '최대 3일 전까지 선택 가능해요!';
  static const String _futurePrimaryMessage = '그 날의 일기는 아직 쓰지 못해요!';
  static const String _retryMessage = '다시 선택해주세요.';

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final normalizedSelected = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );
    final today = _today;
    final daysFromToday = normalizedSelected.difference(today).inDays;

    if (daysFromToday > 0) {
      _showDateWarning(_futurePrimaryMessage);
      return;
    }

    if (daysFromToday < -3) {
      _showDateWarning(_pastLimitPrimaryMessage);
      return;
    }

    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = selectedDay;
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

  Future<void> _showDateWarning(String primaryMessage) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CalendarWarningPopup(
          primaryMessage: primaryMessage,
          secondaryMessage: _retryMessage,
          messageSpacing: 18,
          onClose: () => Navigator.of(dialogContext).pop(),
        );
      },
    );

    if (!mounted) {
      return;
    }

    final today = _today;
    setState(() {
      _selectedDay = today;
      _focusedDay = today;
    });
  }

  double _calendarRowHeight(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return (h * 0.075).clamp(52.0, 68.0);
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
                    MetadataBackButton(onTap: () => context.go(Routes.home)),
                    SizedBox(height: AppSpacing.medium(context)),
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
                    SizedBox(height: AppSpacing.medium(context)),
                    _MonthHeader(
                      monthLabel: monthLabel,
                      onPrevious: _handlePreviousMonth,
                      onNext: _handleNextMonth,
                    ),
                    SizedBox(height: AppSpacing.medium(context)),
                    Container(
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
                            children: _weekdayLabels
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
                            availableGestures:
                                AvailableGestures.horizontalSwipe,
                            rowHeight: _calendarRowHeight(context),
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: AppTextStyles.body12.copyWith(
                                color: Color(0xFFB28A5F),
                                fontWeight: FontWeight.w600
                              ),
                              outsideTextStyle: AppTextStyles.body12.copyWith(
                                color: Color(0xFFc2c0be),
                                fontWeight: FontWeight.w600,
                              ),
                              weekendTextStyle: AppTextStyles.body12.copyWith(
                                color: Color(0xFFB28A5F),
                                fontWeight: FontWeight.w600
                              ),
                              todayTextStyle: AppTextStyles.body12.copyWith(
                                color: Color(0xFFB28A5F),
                                fontWeight: FontWeight.w600
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
                                fontWeight: FontWeight.w600
                              ),
                              cellMargin: const EdgeInsets.symmetric(
                                vertical: 6,
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              dowTextFormatter: (date, _) {
                                return _weekdayLabels[date.weekday - 1];
                              },
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
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                0,
                AppSpacing.horizontal,
                screenPadding.bottom,
              ),
              child: BottomButton(
                text: '날짜 설정 완료',
                onPressed: () {
                  context.go(
                    '${Routes.metadata}/${Routes.imageUpload}',
                    // 💡 여기서 선택된 날짜를 담아서 보냅니다.
                    extra: MetadataImageData(selectedDate: selectedDay),
                  );
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

const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.monthLabel,
    required this.onPrevious,
    required this.onNext,
  });

  final String monthLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  double _calendarRowHeight(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return (h * 0.075).clamp(52.0, 68.0);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
            color: AppColors.subFont,
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
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
            icon: const Icon(Icons.chevron_right),
            color: AppColors.subFont,
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
