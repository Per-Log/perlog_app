import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/chatbot/widgets/chat_bubble.dart';
import 'package:perlog/features/chatbot/widgets/chat_input_field.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';
import 'package:perlog/core/router/routes.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _questions = [
    "오늘 가장 기억에 남는 일을 하나만 떠올려볼까요?",
    "그 일을 떠올렸을 때 어떤 감정이 들었나요?",
    "그 경험이 당신에게 어떤 의미로 남을 것 같나요?",
    "오늘 하루를 돌아봤을 때 스스로에게 해주고 싶은 말이 있다면요?",
  ];

  int _currentStep = 0;
  final List<String> _answers = [];
  late List<Map<String, dynamic>> _messages;

  bool _isFinished = false;
  bool _hasText = false;
  bool _showButton = false;

  static const double chatMaxWidthRatio = 0.75;

  @override
  void initState() {
    super.initState();

    _messages = [
      {'text': _questions[0], 'isMe': false},
    ];

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
      _answers.add(userText);
      _controller.clear();
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _currentStep++;

        if (_currentStep < _questions.length) {
          _messages.add({
            'text': _questions[_currentStep],
            'isMe': false,
          });
        } else {
          _messages.add({
            'text': "오늘 이야기를 잘 들었어요. 정리해볼게요...",
            'isMe': false,
          });

          _isFinished = true;

          Future.delayed(const Duration(milliseconds: 300), () {
            if (!mounted) return;
            setState(() {
              _showButton = true;
            });
          });
        }
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

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];

                return ChatBubble(
                  message: msg['text'],
                  isMe: msg['isMe'],
                  maxWidth:
                      MediaQuery.of(context).size.width * chatMaxWidthRatio,
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: AppSpacing.bottomButtonPadding(context),
        child: _isFinished
            ? AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _showButton ? 1 : 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 400),
                  offset: _showButton
                      ? Offset.zero
                      : const Offset(0, 0.3), 
                  child: BottomButton(
                    text: "오늘의 일기 등록하기",
                    onPressed: () {
                      final diaryText = _answers.join('\n');

                      context.go(
                        Routes.chatbotToDiary,
                        extra: MetadataImageData(
                          selectedDate: DateTime.now(),
                          ocrText: diaryText,
                        ),
                      );
                    },
                    backgroundColor: AppColors.subBackground,
                    borderColor: AppColors.mainFont,
                    textColor: AppColors.mainFont,
                  ),
                ),
              )
            : ChatInputField(
                controller: _controller,
                hasText: _hasText,
                onSend: _sendMessage,
              ),
      ),
    );
  }
}