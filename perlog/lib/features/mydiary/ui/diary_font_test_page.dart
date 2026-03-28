import 'package:flutter/material.dart';
import 'package:perlog/features/mydiary/ui/diary_fonts.dart';
import '../ui/diary_text_styles.dart';

class DiaryFontTestPage extends StatefulWidget {
  const DiaryFontTestPage({super.key});

  @override
  State<DiaryFontTestPage> createState() => _DiaryFontTestPageState();
}

class _DiaryFontTestPageState extends State<DiaryFontTestPage> {
  String selectedFont = DiaryFonts.nanumPen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary Font Test"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "오늘 하루 기록",
                  style: DiaryTextStyles.title(
                    fontFamily: selectedFont,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "오늘은 날씨가 좋았고, 커피를 마시면서 여유를 즐겼다.\n이 폰트가 잘 적용되는지 테스트 중이다.",
                  style: DiaryTextStyles.content(
                    fontFamily: selectedFont,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "2026.03.28",
                  style: DiaryTextStyles.date(
                    fontFamily: selectedFont,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: ListView.builder(
              itemCount: DiaryFonts.all.length,
              itemBuilder: (context, index) {
                final font = DiaryFonts.all[index];

                return ListTile(
                  title: Text(
                    font,
                    style: DiaryTextStyles.preview(
                      fontFamily: font,
                    ),
                  ),
                  trailing: selectedFont == font
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedFont = font;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}