import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold 대신 Material이나 Container를 사용하여 HomeShell의 body로 들어갑니다.
    return Material(
      color: AppColors.background,
      child: Column(
        children: [
          const Expanded(child: Center(child: Text('챗봇과 대화를 시작해보세요!'))),

          // 텍스트 필드 영역 (좌우 30px, 하단 30px 공백)
          Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),
            child: TextField(
              controller: _controller,
              style: TextStyle(color: AppColors.mainFont, fontSize: 13.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                hintText: '오늘은 어떤 하루였나요?',
                hintStyle: TextStyle(fontSize: 12.0, color: AppColors.subFont),

                // 텍스트 유무에 따라 색상이 변하는 전송 화살표
                suffixIcon: IconButton(
                  onPressed: _hasText
                      ? () {
                          print("전송: ${_controller.text}");
                          _controller.clear();
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_circle_right_outlined,
                    color: _hasText
                        ? AppColors.mainFont
                        : AppColors.subFont.withOpacity(0.5),
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
            ),
          ),
        ],
      ),
    );
  }
}
