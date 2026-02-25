import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/metadata/widgets/back_button.dart';
import 'package:perlog/features/metadata/widgets/calendar_content.dart';
import 'package:perlog/features/metadata/widgets/calendar_header.dart';
import 'package:perlog/features/metadata/widgets/calendar_warning_popup.dart';
import 'package:perlog/features/metadata/widgets/month_header.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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
    const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final screenPadding = AppSpacing.screen(context);
    final selectedDay = _selectedDay ?? _focusedDay;
    final selectedLabel = DateFormat(
      'yyyy년 MM월 dd일 EEEE',
      'ko_KR',
    ).format(selectedDay);
    final monthLabel =
        DateFormat('yyyy년 MM월', 'ko_KR').format(_focusedDay);

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
                    // 이전 
                    MetadataBackButton(
                        onTap: () => context.go(Routes.home)),
                    
                    SizedBox(height: AppSpacing.small(context)),

                    // 원하는 날짜를 선택해주세요
                    CalendarHeader(selectedLabel: selectedLabel),
                    SizedBox(height: AppSpacing.medium(context)),

                    // 오늘 날짜, 월간 이동
                    MonthHeader(
                      monthLabel: monthLabel,
                      onPrevious: _handlePreviousMonth,
                      onNext: _handleNextMonth,
                    ),
                    
                    SizedBox(height: AppSpacing.medium(context)+5),

                    // 캘린더
                    CalendarContent(
                      firstDay: _firstDay,
                      lastDay: _lastDay,
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay,
                      rowHeight: _calendarRowHeight(context),
                      onDaySelected: _handleDaySelected,
                      onPageChanged: _handlePageChanged,
                      onCalendarCreated: (controller) {
                        _pageController = controller;
                      },
                      weekdayLabels: _weekdayLabels,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: AppSpacing.bottomButtonPadding(context),
        child: BottomButton(
          text: '날짜 설정 완료',
          onPressed: () {
            context.go(
              '${Routes.metadata}/${Routes.imageUpload}',
              extra:
                  MetadataImageData(selectedDate: selectedDay),
            );
          },
          enabled: true,
          backgroundColor: AppColors.subBackground,
          borderColor: AppColors.subBackground,
          textColor: AppColors.mainFont,
        ),
      ),
    );
  }
}