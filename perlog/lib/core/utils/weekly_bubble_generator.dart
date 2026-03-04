import 'package:perlog/core/models/diary_bubble.dart';

class WeeklyBubbleGenerator {
  static List<DiaryBubble> generate({
    required DateTime today,
    required Set<DateTime> diaryDates,
  }) {
    // 이번 주 월요일
    final monday =
        today.subtract(Duration(days: today.weekday - 1));

    return List.generate(7, (index) {
      final date = monday.add(Duration(days: index));

      final hasDiary = diaryDates.any((d) =>
          d.year == date.year &&
          d.month == date.month &&
          d.day == date.day);

      return DiaryBubble(
        date: date,
        hasDiary: hasDiary,
      );
    });
  }
}