import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';

class OnboardingProfilePage extends StatefulWidget {
  const OnboardingProfilePage({super.key});

  @override
  State<OnboardingProfilePage> createState() =>
      _OnboardingProfilePageState();
}

class _OnboardingProfilePageState extends State<OnboardingProfilePage> {
  final _nicknameController = TextEditingController();
  final _focusNode = FocusNode();

  bool get isCompleted =>
      _nicknameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nicknameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// 프로필 이미지
              Center(
                child: SizedBox(
                  width: 176,
                  height: 176,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 176,
                        height: 176,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.mainFont,
                            width: 3,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 176 * 0.1,
                        bottom: 176 * 0.01,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.subBackground,
                            border: Border.all(
                              color: AppColors.mainFont,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 17.8,
                              height: 18,
                              child: Image.asset(
                                'assets/icons/camera.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// 별명 입력
              Row(
                children: [
                  const SizedBox(width: 30),
                  Text(
                    '별명',
                    style: AppTextStyles.body20Medium
                        .copyWith(color: AppColors.mainFont),
                  ),
                  const SizedBox(width: 20),

                  Expanded(
                    child: TextField(
                      controller: _nicknameController,
                      focusNode: _focusNode,
                      onChanged: (_) => setState(() {}),

                      textAlignVertical: TextAlignVertical.center,
                      style: AppTextStyles.body18SemiBold
                          .copyWith(color: AppColors.mainFont),

                      decoration: InputDecoration(
                        isDense: true,               
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,                
                          horizontal: 16,
                        ),

                        filled: true,
                        fillColor: isCompleted
                            ? AppColors.subBackground
                            : Colors.transparent,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isCompleted
                                ? Colors.transparent
                                : AppColors.subFont,
                            width: 1.5,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.subFont,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(width: 30)
                ],
              ),

              const SizedBox(height: 32),

              /// 알림 설정
              _SettingItem(
                title: '알림 설정',
                color: AppColors.mainFont,
              ),

              const SizedBox(height: 20),

              /// 잠금 설정
              _SettingItem(
                title: '잠금 설정',
                color: AppColors.mainFont,
              ),

              const Spacer(),

              /// 시작하기 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.mainFont),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    '시작하기',
                    style: TextStyle(
                      color: AppColors.mainFont,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}


class _SettingItem extends StatelessWidget {
  final String title;
  final Color color;

  const _SettingItem({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.radio_button_unchecked, color: color),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Icon(Icons.help_outline, size: 16, color: color.withOpacity(0.6)),
      ],
    );
  }
}
