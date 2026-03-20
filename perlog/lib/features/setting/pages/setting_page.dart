import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/models/notification_period.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/onboarding/widgets/notification_period_sheet.dart';
import 'package:perlog/features/setting/widgets/settings_section.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notificationEnabled = true;
  NotificationPeriod _period = NotificationPeriod.oneDay;

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
                  "title": "잠금 사용 설정",
                  "onTap": () {},
                },
                {
                  "title": "비밀번호 변경",
                  "onTap": () => context.push('${Routes.settings}/${Routes.settingsPinCheck}'),
                },
              ],
            ),

            const Divider(),

            SettingsSection(
              title: "앱 설정",
              items: [
                {
                  "title": "알림 사용 설정",
                  "onTap": () {},
                },
                {
                  "title": "알림 주기 설정",
                  "onTap": () {
                    showNotificationPeriodSheet(
                      context: context,
                      current: _period,
                      onSelected: (value) {
                        setState(() {
                          _period = value;
                        });
                      },
                    );
                  },
                },
                {
                  "title": "시스템 알림 설정",
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
                  "title": "앱 튜토리얼",
                  "onTap": () => context.push('${Routes.settings}/${Routes.settingsTutorial}'),
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