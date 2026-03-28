import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final double maxWidth;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.background
              : AppColors.subBackground,
          border: isMe
              ? Border.all(color: AppColors.mainFont)
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Text(
          message,
          style: AppTextStyles.body16.copyWith(
            color: AppColors.mainFont,
          ),
        ),
      ),
    );
  }
}