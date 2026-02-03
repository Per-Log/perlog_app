import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/models/notification_period.dart';
import 'package:perlog/features/onboarding/widgets/profile_header.dart';
import 'package:perlog/features/onboarding/widgets/notification_selector.dart';
import 'package:perlog/features/onboarding/widgets/notification_period_sheet.dart';

class NotificationSettingSection extends StatelessWidget {
  final bool enabled;
  final NotificationPeriod period;
  final VoidCallback onToggle;
  final ValueChanged<NotificationPeriod> onChangePeriod;

  const NotificationSettingSection({
    super.key,
    required this.enabled,
    required this.period,
    required this.onToggle,
    required this.onChangePeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ProfileHeader(
            title: '알림 설정',
            checked: enabled,
            message: '알림을 켜두면 하루를 돌아볼 시간을 놓치지 않아요.',
            onToggle: onToggle,
          ),
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: enabled
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 20 + 20 + AppSpacing.small(context),
                    top: AppSpacing.small(context),
                  ),
                  child: _NotificationSettingBody(
                    period: period,
                    onTap: () {
                      showNotificationPeriodSheet(
                        context: context,
                        current: period,
                        onSelected: onChangePeriod,
                      );
                    },
                  ),
                )
              : SizedBox(height: AppSpacing.medium(context)),
        ),
      ],
    );
  }
}

class _NotificationSettingBody extends StatelessWidget {
  final NotificationPeriod period;
  final VoidCallback onTap;

  const _NotificationSettingBody({
    required this.period,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '알림 주기',
          style: AppTextStyles.body20Medium
              .copyWith(color: AppColors.mainFont),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: NotificationPeriodSelector(
            value: period,
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }
}
