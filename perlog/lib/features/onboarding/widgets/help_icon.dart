import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';

class HelpIcon extends StatefulWidget {
  final Color textColor;
  final String message;

  const HelpIcon({
    super.key,
    required this.textColor,
    required this.message,
  });

  @override
  State<HelpIcon> createState() => _HelpIconState();
}

class _HelpIconState extends State<HelpIcon> {
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 바깥 터치 시 닫기
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
              ),
            ),

            // 말풍선
            Positioned(
              left: AppSpacing.horizontal + 30,
              top: offset.dy - 44,
              child: _TooltipBubble(
                message: widget.message,
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _overlayEntry == null ? _showOverlay() : _removeOverlay();
      },
      child: SizedBox(
        width: 16,
        height: 16,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.subBackground
              ),
            ),
            Text(
              '?',
              style: AppTextStyles.body12.copyWith(color: AppColors.mainFont)
            ),
          ],
        ),
      ),
    );
  }
}

class _TooltipBubble extends StatelessWidget {
  final String message;

  const _TooltipBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.emptyBackground,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          message,
          style: AppTextStyles.body14
              .copyWith(color: AppColors.mainFont),
        ),
      ),
    );
  }
}
