import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();

  // 1. 자동 스크롤을 위한 스크롤 컨트롤러 추가
  final ScrollController _scrollController = ScrollController();

  // 메시지 데이터를 저장할 리스트 (Map 형태로 사용하여 보낸 사람 구분)
  final List<Map<String, dynamic>> _messages = [
    {'text': '안녕하세요! 오늘 하루는 어떠셨나요?', 'isMe': false},
  ];

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

  // 2. 스크롤을 가장 아래로 내리는 함수
  void _scrollToBottom() {
    // 프레임이 그려진 직후에 실행되도록 하여 리스트 업데이트 후 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 3. 메시지 전송 및 챗봇 응답 로직
  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text.trim();

    setState(() {
      _messages.add({'text': userText, 'isMe': true});
      _controller.clear();
    });
    _scrollToBottom();

    // 1초 뒤에 챗봇 답변 생성
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': '정말 멋진 하루네요! 더 자세히 들려주실 수 있나요?',
            'isMe': false,
          });
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose(); // 컨트롤러 해제 필수
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
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
          IconButton(
            onPressed: () => context.go(Routes.home),
            icon: Icon(
              Icons.home_outlined,
              size: 30,
              color: AppColors.mainFont,
            ),
          ),
          const SizedBox(width: 17),
        ],
      ),
      body: Column(
        children: [
          // 채팅 메시지 리스트 영역
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // 스크롤 컨트롤러 연결
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg['text'], msg['isMe']);
              },
            ),
          ),

          // 입력 창 영역
          Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              style: TextStyle(color: AppColors.mainFont, fontSize: 13.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                hintText: '오늘은 어떤 하루였나요?',
                hintStyle: TextStyle(fontSize: 12.0, color: AppColors.subFont),
                suffixIcon: IconButton(
                  onPressed: _hasText ? _sendMessage : null,
                  icon: Icon(
                    Icons.arrow_circle_right,
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

  // 4. 개선된 말풍선 위젯 (나/챗봇 구분)
  Widget _buildChatBubble(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.mainFont : Colors.white,
          border: isMe
              ? null
              : Border.all(color: AppColors.subFont.withOpacity(0.3)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : AppColors.mainFont,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
