import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/utils/weekly_bubble_generator.dart';
import 'package:perlog/features/home/widgets/weekly_streak.dart';
import 'package:perlog/features/metadata/widgets/calendar_content.dart';
import 'package:perlog/features/metadata/widgets/month_header.dart';

class MyDiary extends StatefulWidget {
  const MyDiary({super.key});

  @override
  State<MyDiary> createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  static final DateTime _firstDay = DateTime(2000, 1, 1);
  static final DateTime _lastDay = DateTime(2100, 12, 31);

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  PageController? _pageController;

  // 임시 데이터
  final Set<DateTime> diaryDates = {
    DateTime(2026, 3, 1),
    DateTime(2026, 3, 2),
  };

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    // TODO: 팝업 띄워서 일기 상세
  }

  void _handlePageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate =
        DateFormat('yyyy년 M월 d일 E요일', 'ko_KR').format(today);

    final weeklyBubbles = WeeklyBubbleGenerator.generate(
      today: today,
      diaryDates: diaryDates,
    );

    final monthLabel =
        DateFormat('yyyy년 MM월', 'ko_KR').format(_focusedDay);

    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.screen(context).copyWith(top: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: AppTextStyles.body18.copyWith(
                      color: AppColors.mainFont,
                    ),
                  ),
                  SizedBox(height: AppSpacing.small(context)),
                  WeeklyStreak(bubbles: weeklyBubbles),
                  SizedBox(height: AppSpacing.medium(context)),

                  MonthHeader(
                    monthLabel: monthLabel,
                    onPrevious: () => _pageController?.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    ),
                    onNext: () => _pageController?.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    ),
                  ),

                  SizedBox(height: AppSpacing.medium(context) + 5),

                  CalendarContent(
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    rowHeight: 60,
                    onDaySelected: _handleDaySelected,
                    onPageChanged: _handlePageChanged,
                    onCalendarCreated: (controller) {
                      _pageController = controller;
                    },
                    weekdayLabels: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}