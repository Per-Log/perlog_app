import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:perlog/core/widgets/bottom_button.dart';

/// PIN 번호 입력을 위한 공통 레이아웃 위젯
// PinEntryContent.dart

class PinEntryContent extends StatefulWidget {
  const PinEntryContent({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onSubmit,
    this.onBack,
    this.showBackButton = true,
    this.pinLength = 4,
    this.contentPadding,
  });

  final String title;
  final String buttonText;

  /// 🔥 핵심: PIN 전달
  final Function(String pin) onSubmit;

  final VoidCallback? onBack;
  final bool showBackButton;
  final int pinLength;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<PinEntryContent> createState() => _PinEntryContentState();
}

class _PinEntryContentState extends State<PinEntryContent> {
  final List<int> _digits = [];

  bool get _isComplete => _digits.length == widget.pinLength;

  void _addDigit(int digit) {
    if (_digits.length >= widget.pinLength) return;
    setState(() => _digits.add(digit));
  }

  void _removeDigit() {
    if (_digits.isEmpty) return;
    setState(() => _digits.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: widget.onBack ??
                      () => Navigator.of(context).maybePop(),
                  child: Text(
                    '이전',
                    style: AppTextStyles.body16.copyWith(
                      color: AppColors.subFont,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.large(context) + 30),

              Center(
                child: Text(
                  widget.title,
                  style: AppTextStyles.body20Medium.copyWith(
                    color: AppColors.mainFont,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.large(context)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.pinLength, (index) {
                  final isFilled = index < _digits.length;
                  return Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 17),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled
                          ? AppColors.mainFont
                          : AppColors.subFont,
                    ),
                  );
                }),
              ),

              SizedBox(height: AppSpacing.large(context) + 20),

              _PinKeypad(
                onDigitPressed: _addDigit,
                onBackspacePressed: _removeDigit,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),

      /// 🔥 핵심 버튼
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.bottomButtonPadding(context),
          child: BottomButton(
            text: widget.buttonText,
            enabled: _isComplete,
            onPressed: () {
              if (!_isComplete) return;

              final pin = _digits.join();
              widget.onSubmit(pin);
            },
            backgroundColor: _isComplete
                ? AppColors.subBackground
                : AppColors.background,
            borderColor: _isComplete
                ? Colors.transparent
                : AppColors.subFont,
            textColor: AppColors.mainFont,
            textStyle: AppTextStyles.body20Medium,
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

  static const double _keySize = 70;
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
                width: 25,
                height: 25,
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
                  fontSize: 30,
                ),
              ),
      ),
    );
  }
}