import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// PIN 번호 입력을 위한 공통 레이아웃 위젯
class PinEntryContent extends StatefulWidget {
  const PinEntryContent({
    super.key,
    required this.title, // 화면 중앙에 표시될 제목
    required this.buttonText, // 하단 확인 버튼에 들어갈 문구
    required this.onSubmit, // PIN 입력 완료 후 버튼을 눌렀을 때의 동작
    this.onBack, // 이전 버튼 동작
    this.showBackButton = true,
    this.pinLength = 4, // 입력받을 PIN의 길이
  });

  final String title;
  final String buttonText;
  final VoidCallback onSubmit;
  final VoidCallback? onBack;
  final bool showBackButton;
  final int pinLength;

  // 위 내용 받아서 아래로 상속
  @override
  State<PinEntryContent> createState() => _PinEntryContentState();
}

class _PinEntryContentState extends State<PinEntryContent> {
  final List<int> _digits = [];

  bool get _isComplete => _digits.length == widget.pinLength;

  // pin 네 자리 이상일 시 cutting 로직
  void _addDigit(int digit) {
    if (_digits.length >= widget.pinLength) {
      return;
    }
    setState(() => _digits.add(digit));
  }

  void _removeDigit() {
    if (_digits.isEmpty) {
      return;
    }
    setState(() => _digits.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: widget.showBackButton
                    ? GestureDetector(
                        onTap:
                            widget.onBack ??
                            () => Navigator.of(context).maybePop(),
                        child: Text(
                          '이전',
                          style: AppTextStyles.body16.copyWith(
                            color: AppColors.subFont,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 51),
              Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: AppColors.mainFont,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 44),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.pinLength, (index) {
                  final isFilled = index < _digits.length;
                  return Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? AppColors.mainFont : AppColors.subFont,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 60),
              _PinKeypad(
                onDigitPressed: _addDigit,
                onBackspacePressed: _removeDigit,
              ),
              const Spacer(),
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: _isComplete ? widget.onSubmit : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _isComplete
                          ? AppColors.mainFont
                          : AppColors.subFont,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(
                      color: _isComplete
                          ? AppColors.mainFont
                          : AppColors.subFont,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinKeypad extends StatelessWidget {
  const _PinKeypad({
    required this.onDigitPressed,
    required this.onBackspacePressed,
  });

  final ValueChanged<int> onDigitPressed;
  final VoidCallback onBackspacePressed;

  static const double _keySize = 50;
  static const double _keyGap = 24;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow([1, 2, 3]),
        const SizedBox(height: 20),
        _buildRow([4, 5, 6]),
        const SizedBox(height: 20),
        _buildRow([7, 8, 9]),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: _keySize, height: _keySize),
            const SizedBox(width: _keyGap),
            _PinKey(label: '0', onTap: () => onDigitPressed(0)),
            const SizedBox(width: _keyGap),
            _PinKey(
              icon: SvgPicture.asset(
                'assets/icons/arrow_left_fill.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  AppColors.mainFont,
                  BlendMode.srcIn,
                ),
              ),
              onTap: onBackspacePressed),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<int> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PinKey(
          label: digits[0].toString(),
          onTap: () => onDigitPressed(digits[0]),
        ),
        const SizedBox(width: _keyGap),
        _PinKey(
          label: digits[1].toString(),
          onTap: () => onDigitPressed(digits[1]),
        ),
        const SizedBox(width: _keyGap),
        _PinKey(
          label: digits[2].toString(),
          onTap: () => onDigitPressed(digits[2]),
        ),
      ],
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({this.label, this.icon, required this.onTap});

  final String? label;
  final Widget? icon;
  final VoidCallback onTap;

  static const double _keySize = _PinKeypad._keySize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _keySize,
      height: _keySize,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          foregroundColor: AppColors.mainFont,
        ),
        child: icon != null
            ? icon!
            : Text(
                label ?? '',
                style: AppTextStyles.body20Medium.copyWith(
                  color: AppColors.mainFont,
                  fontSize: 27,
                ),
              ),
      ),
    );
  }
}