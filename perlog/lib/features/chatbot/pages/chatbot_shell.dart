import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';

class ChatbotShell extends StatelessWidget {
  final Widget child;

  const ChatbotShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 21,
        
        title: Text(
          'Per-Log',
          style: AppTextStyles.headline28.copyWith(
            color: AppColors.mainFont,
          ),
        ),

        actionsPadding: const EdgeInsets.only(right: 5),

        actions: [
          IconButton(
            onPressed: () => context.go(Routes.home),
            icon: Image.asset(
              'assets/icons/line_home.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),

      body: child, // 내부 콘텐츠가 교체되는 영역
    );
  }
}