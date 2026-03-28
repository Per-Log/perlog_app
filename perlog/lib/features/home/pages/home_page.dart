import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:intl/intl.dart';
import 'package:perlog/features/home/widgets/perfume_shelf.dart';
import 'package:perlog/features/home/widgets/weekly_streak.dart';
import 'package:perlog/core/utils/weekly_bubble_generator.dart';
import 'package:perlog/domain/onboarding/onboarding_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<void> _loadNickname() async {
    final nickname = await OnboardingService.getNickname();

    if (!mounted) return;

    setState(() {
      _nickname = nickname ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate =
        DateFormat('yyyy년 M월 d일 E요일', 'ko_KR').format(today);

    final Set<DateTime> diaryDates = {
      DateTime(2026, 3, 23),
      DateTime(2026, 3, 26),
    };

    final weeklyBubbles = WeeklyBubbleGenerator.generate(
      today: today,
      diaryDates: diaryDates,
    );

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
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: PerfumeShelf(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontal + 10,
                vertical: AppSpacing.vertical - 20,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _nickname,
                      style: AppTextStyles.body20Medium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainFont,
                      ),
                    ),
                    TextSpan(
                      text: '님, 오늘 하루는 어떠셨나요?',
                      style: AppTextStyles.body20Medium.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 45),
              child: BottomButton(
                text: "일기 업로드 하기",
                onPressed: () {
                  context.go('${Routes.metadata}/${Routes.calendar}');
                },
                enabled: true,
                backgroundColor: AppColors.subBackground,
                borderColor: Colors.transparent,
                textColor: AppColors.mainFont,
                textStyle: AppTextStyles.body20Medium,
                trailing: Image.asset(
                  'assets/icons/right_arrow_circle.png',
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}