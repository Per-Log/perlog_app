import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/features/metadata/pages/metadata_image_data.dart';

class ChatbotTodiary extends StatefulWidget {
  const ChatbotTodiary({super.key, this.args});

  final MetadataImageData? args;

  @override
  State<ChatbotTodiary> createState() => _ChatbotTodiaryState();
}

class _ChatbotTodiaryState extends State<ChatbotTodiary> {
  late final TextEditingController _ocrTextController;
  static const double _lineGap = 40;
  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 12;

  @override
  void initState() {
    super.initState();
    _ocrTextController = TextEditingController(
      text: widget.args?.ocrText ?? '여기에 챗봇 대화 데이터가 나옴',
    );
  }

  @override
  void dispose() {
    _ocrTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenPadding.left,
                  screenPadding.top,
                  screenPadding.right,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => context.go(Routes.home),
                        child: Text(
                          '홈으로',
                          style: AppTextStyles.body16.copyWith(
                            color: AppColors.subFont,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.large(context)-5),
                    Text(
                      '일기의 내용을 확인해주세요.',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    Text(
                      '아래 내용들은 수정할 수 있어요!',
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    SizedBox(height: AppSpacing.vertical),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.subFont),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: _NotebookLinePainter(
                                            lineGap: _lineGap,
                                            topInset: _verticalPadding,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: _horizontalPadding,
                                          vertical: _verticalPadding,
                                        ),
                                        child: TextField(
                                          controller: _ocrTextController,
                                          minLines: 1,
                                          maxLines: null,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          style:
                                              AppTextStyles.body16.copyWith(
                                            color: Colors.black,
                                            height: _lineGap /
                                                AppTextStyles.body16.fontSize!,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            isCollapsed: true,
                                            hintText: '내용을 확인하고 수정해 주세요.',
                                            hintStyle:
                                                AppTextStyles.body16.copyWith(
                                              color: AppColors.subFont,
                                              height: _lineGap /
                                                  AppTextStyles
                                                      .body16.fontSize!,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.horizontal,
                16,
                AppSpacing.horizontal,
                screenPadding.bottom,
              ),
              child: BottomButton(
                text: '저장하기',
                onPressed: () => context.go(
                  '${Routes.metadata}/${Routes.diaryAnalysis}',
                  extra: widget.args,
                ),
                enabled: true,
                backgroundColor: AppColors.subBackground,
                borderColor: AppColors.subBackground,
                textColor: AppColors.mainFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotebookLinePainter extends CustomPainter {
  const _NotebookLinePainter({required this.lineGap, required this.topInset});

  final double lineGap;
  final double topInset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD6C2A0)
      ..strokeWidth = 1;

    for (double y = topInset + lineGap; y < size.height; y += lineGap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookLinePainter oldDelegate) {
    return oldDelegate.lineGap != lineGap || oldDelegate.topInset != topInset;
  }
}
