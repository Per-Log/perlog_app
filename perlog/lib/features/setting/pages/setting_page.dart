import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/setting/widgets/settings_section.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: AppSpacing.screen(context).copyWith(top: 0, left: 30),
          children: [
            SettingsSection(
              title: "계정",
              items: [
                {
                  "title": "나의 정보",
                  "onTap": () => context.go('${Routes.onboarding}/${Routes.profile}'),
                },
                {
                  "title": "잠금 설정",
                  "onTap": () => context.go('${Routes.onboarding}/${Routes.pinConfirm}'),
                },
              ],
            ),

            const Divider(),

            SettingsSection(
              title: "앱 설정",
              items: [
                {
                  "title": "알림 설정",
                  "onTap": () {},
                },
                {
                  "title": "튜토리얼",
                  "onTap": () {},
                },
              ],
            ),

            const Divider(),

            SettingsSection(
              title: "정보",
              items: [
                {
                  "title": "About Perlog",
                  "onTap": () {},
                },
                {
                  "title": "개인정보 처리 방침",
                  "onTap": () {},
                },
                {
                  "title": "라이선스",
                  "onTap": () {},
                },
              ],
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "25-26 SKKU SKKAI",
                style: AppTextStyles.body12.copyWith(
                  color: AppColors.subFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}