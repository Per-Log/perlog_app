import 'package:flutter/cupertino.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/models/diary_bubble.dart';
import 'package:perlog/features/home/widgets/diary_bubble_item.dart';

class WeeklyStreak extends StatelessWidget {
  final List<DiaryBubble> bubbles;

  const WeeklyStreak({super.key, required this.bubbles});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // TODO: mediaquery
      decoration: BoxDecoration(
        color: AppColors.paleBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: bubbles.map((bubble) {
          return DiaryBubbleItem(active: bubble.hasDiary);
        }).toList(),
      ),
    );
  }
}
