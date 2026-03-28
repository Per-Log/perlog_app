import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/features/mydiary/ui/diary_fonts.dart';
import 'package:perlog/features/mydiary/ui/diary_text_styles.dart';
import 'package:perlog/features/mydiary/widgets/font_selector.dart';

class DiaryReportCard extends StatefulWidget {
  final DateTime selectedDate;

  const DiaryReportCard({
    super.key,
    required this.selectedDate,
  });

  @override
  State<DiaryReportCard> createState() => _DiaryReportCardState();
}

class _DiaryReportCardState extends State<DiaryReportCard> {
  String selectedFont = DiaryFonts.nanumPen;

  void _showFontPicker() {
    final fonts = DiaryFonts.all;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6, // 🔥 핵심
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ListView(
                children: fonts.map((font) {
                  final isSelected = font == selectedFont;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      DiaryFonts.getDisplayName(font),
                      style: DiaryTextStyles.content(
                        fontFamily: font,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: AppColors.mainFont)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedFont = font;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'yyyy년 M월 d일 E요일',
      'ko_KR',
    ).format(widget.selectedDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendar,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.selectedBackground,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: AppTextStyles.body18.copyWith(
              color: AppColors.mainFont,
            ),
          ),

          const SizedBox(height: 12),

          FontSelector(
            selectedFont: selectedFont,
            onTap: _showFontPicker,
          ),

          const SizedBox(height: 16),

          Text(
            '오늘의 일기를 보여드립니다.',
            style: DiaryTextStyles.content(
              fontFamily: selectedFont,
              color: AppColors.mainFont,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 20), // TODO: mediaquery
              Image.asset(
                'assets/icons/perfume.png',
                height: 52,
                width: 52,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(
                      Icons.wine_bar,
                      size: 52,
                      color: Colors.brown,
                    ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '~~한 하루였군요!',
                      style: AppTextStyles.body14.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '오늘의 향수 잡다한 설명 왈라라랄랄',
                      style: AppTextStyles.body14.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 해시태그 바
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.emptyBackground,
            ),
            child: Center(
              child: Text(
                '#복숭아향 #과일향 #기쁨 #설렘',
                style: AppTextStyles.body16Medium.copyWith(
                  color: AppColors.mainFont,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          Text(
            '파이 차트 (위젯 구현 필요)',
            style: AppTextStyles.body14.copyWith(
              color: AppColors.mainFont,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '그래프 (위젯 구현 필요)',
            style: AppTextStyles.body14.copyWith(
              color: AppColors.mainFont,
            ),
          ),
        ],
      ),
    );
  }
}