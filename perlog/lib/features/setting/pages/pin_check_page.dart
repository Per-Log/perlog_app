import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/features/onboarding/widgets/pin_entry_content.dart';
import 'package:perlog/domain/lock/lock_service.dart';
import 'package:perlog/core/router/routes.dart';

class PinCheckPage extends StatelessWidget {
  const PinCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PinEntryContent(
      title: '현재 비밀번호를 입력해주세요.',
      buttonText: '확인',
      showBackButton: true,

      onSubmit: (inputPin) async {
        final savedPin = await LockService.getPin();

        // PIN 없음 → 바로 재설정
        if (savedPin == null) {
          final result = await context.push(
            '${Routes.settings}/${Routes.settingsPinSet}',
          );

          if (result == true) {
            if (!context.mounted) return;
            context.pop(true);
          }
          return;
        }

        // PIN 틀림
        if (inputPin != savedPin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('비밀번호가 틀렸습니다.')),
          );
          return;
        }

        // PIN 맞음 → 재설정 화면
        final result = await context.push(
          '${Routes.settings}/${Routes.settingsPinSet}',
        );

        if (result == true) {
          if (!context.mounted) return;
          context.pop(true);
        }
      },
    );
  }
}