import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.hasText,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 1,
      maxLines: 5,
      style: AppTextStyles.body16.copyWith(
        color: AppColors.mainFont,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        hintText: '이곳에 입력해주세요.',
        hintStyle: AppTextStyles.body16.copyWith(
          color: AppColors.subFont,
        ),
        suffixIcon: IconButton(
          onPressed: hasText ? onSend : null,
          icon: Icon(
            Icons.arrow_circle_right,
            size: 28,
            color: hasText
                ? AppColors.mainFont
                : AppColors.subFont,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.subFont, width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainFont, width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}