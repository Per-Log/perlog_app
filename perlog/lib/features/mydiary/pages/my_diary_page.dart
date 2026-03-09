import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/utils/weekly_bubble_generator.dart';
import 'package:perlog/features/home/widgets/weekly_streak.dart';
import 'package:perlog/features/metadata/widgets/calendar_content.dart';
import 'package:perlog/features/metadata/widgets/month_header.dart';
import 'package:perlog/features/mydiary/widgets/no_diary_card.dart';
import 'package:perlog/features/mydiary/widgets/diary_report_card.dart';

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
  final Set<DateTime> diaryDates = {DateTime(2026, 3, 1), DateTime(2026, 3, 2)};

  bool hasDiary = true; // 변경하며 테스트, TODO: db조회

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
    final formattedDate = DateFormat('yyyy년 M월 d일 E요일', 'ko_KR').format(today);

    final weeklyBubbles = WeeklyBubbleGenerator.generate(
      today: today,
      diaryDates: diaryDates,
    );

    final monthLabel = DateFormat('yyyy년 MM월', 'ko_KR').format(_focusedDay);

    final selectedFormattedDate = DateFormat('yyyy년 M월 d일 E요일', 'ko_KR').format(_selectedDay);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
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

                      // 상태 토글용 텍스트 버튼
                      // 추후 삭제 필요
                      // SizedBox(height: AppSpacing.medium(context)),
                      // TextButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           hasDiary = !hasDiary;
                      //         });
                      //       },
                      //       child: Text(
                      //         hasDiary ? '일기 있음' : '일기 없음',
                      //         style: const TextStyle(fontSize: 12),
                      //       ),
                      //     ),

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
                        weekdayLabels: const [
                          'S',
                          'M',
                          'T',
                          'W',
                          'T',
                          'F',
                          'S',
                        ],
                      ),

                      SizedBox(height: AppSpacing.medium(context)),

                      hasDiary
                          ? DiaryReportCard(selectedDate: _selectedDay)
                          : NoDiaryCard(selectedDate: _selectedDay,),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
