import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {'text': '안녕하세요! 오늘 하루는 어떠셨나요?', 'isMe': false},
  ];

  bool _hasText = false;
  static const double chatMaxWidthRatio = 0.75;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  void _scrollToBottom() {
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

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text.trim();

    setState(() {
      _messages.add({'text': userText, 'isMe': true});
      _controller.clear();
    });

    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _messages.add({
          'text': '정말 멋진 하루네요! 더 자세히 들려주실 수 있나요?',
          'isMe': false,
        });
      });

      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,

      /// 🔹 채팅 리스트
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg['text'], msg['isMe']);
              },
            ),
          ),
        ],
      ),

      /// 🔥 입력창을 여기로 이동
      bottomNavigationBar: Padding(
        padding: AppSpacing.bottomButtonPadding(context),
        child: _buildInputField(),
      ),
    );
  }

Widget _buildInputField() {
  return SizedBox(
    width: MediaQuery.of(context).size.width * chatMaxWidthRatio,
    child: TextField(
      controller: _controller,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 1,
      maxLines: 5, // 원하는 만큼 조절
      style: AppTextStyles.body16.copyWith(
        color: AppColors.mainFont,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        hintText: '오늘은 어떤 하루였나요?',
        hintStyle: AppTextStyles.body16.copyWith(
          color: AppColors.subFont,
        ),
        suffixIcon: IconButton(
          onPressed: _hasText ? _sendMessage : null,
          icon: Icon(
            Icons.arrow_circle_right,
            size: 28,
            color: _hasText
                ? AppColors.mainFont
                : AppColors.subFont,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.subFont,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.mainFont,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}

  Widget _buildChatBubble(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * chatMaxWidthRatio
        ),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.background
              : AppColors.subBackground,
          border: isMe
              ? Border.all(color: AppColors.mainFont)
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: AppTextStyles.body16.copyWith(color: AppColors.mainFont), // medium 적용할지 상의 TODO
        ),
      ),
    );
  }
}