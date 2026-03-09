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
                  "title": "내 정보 수정",
                  "onTap": () => context.push('${Routes.settings}/${Routes.settingsProfile}'),
                },
                {
                  "title": "잠금 설정",
                  "onTap": () => context.push('${Routes.settings}/${Routes.settingsPinCheck}'),
                },
              ],
            ),

            const Divider(),

            SettingsSection(
              title: "앱 설정",
              items: [
                {
                  "title": "알림 주기 설정",
                  "onTap": () {}, // 하단 바
                },
                {
                  "title": "시스템 알림 설정",
                  "onTap": () {}, // 시스템 연결
                },
              ],
            ),

            const Divider(),

            SettingsSection(
              title: "정보",
              items: [
                {
                  "title": "About Perlog",
                  "onTap": () {}, // 웹 연결 (노션)
                },
                {
                  "title": "앱 튜토리얼",
                  "onTap": () => context.push('${Routes.settings}/${Routes.settingsTutorial}'),
                },
                {
                  "title": "개인정보 처리 방침",
                  "onTap": () {}, // 웹 연결 (노션)
                },
                {
                  "title": "라이선스",
                  "onTap": () {}, // 웹 연결 (노션) / 팝업 처리
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