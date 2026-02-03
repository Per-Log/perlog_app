import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';

class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 17),
          child: SizedBox(
            width: 108,
            height: 35,
            child: Text(
              'Per-Log',
              style: AppTextStyles.headline28.copyWith(
                color: AppColors.mainFont,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 17),
            child: Icon(
              Icons.home_outlined,
              size: 30.0,
              color: AppColors.mainFont,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Spacer(),
          TextField(
            style: TextStyle(color: AppColors.mainFont, fontSize: 13.0),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              labelText: '오늘은 어떤 하루였나요?',
              labelStyle: TextStyle(fontSize: 12.0, color: AppColors.subFont),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.subFont, width: 1.5),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // 아이콘들을 일정 간격으로 배분
          children: [
            _buildBottomItem(Icons.home, '홈'),
            _buildBottomItem(Icons.book, '나의 일기'),
            _buildBottomItem(Icons.settings, '설정'),
          ],
        ),
      ),
    );
  }
}

// 아이템 빌더 함수 (코드 중복 방지)
Widget _buildBottomItem(IconData icon, String label) {
  return InkWell(
    // 클릭 효과를 위해 추가
    onTap: () {},
    child: Column(
      mainAxisSize: MainAxisSize.min, // 중요: 컬럼 크기를 최소로
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Icon(icon, color: AppColors.mainFont),
        ),
        Text(
          label,
          style: AppTextStyles.body11.copyWith(color: AppColors.mainFont),
        ),
      ],
    ),
  );
}
