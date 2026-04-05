import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/features/onboarding/widgets/pin_entry_content.dart';
import 'package:perlog/domain/lock/lock_service.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/core/utils/security_utils.dart';

class PinCheckPage extends StatelessWidget {
  const PinCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PinEntryContent(
      title: '비밀번호를 입력해주세요.',
      buttonText: '확인',
      showBackButton: false,

      onSubmit: (inputPin) async {
        final savedPin = await LockService.getPin();

        if (savedPin == null) {
          context.go(Routes.home);
          return;
        }

        final hashedInputPin = SecurityUtils.hashPin(inputPin);

        if (hashedInputPin != savedPin) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('비밀번호가 틀렸습니다.')));
          return;
        }

        if (!context.mounted) return;
        context.go(Routes.home);
      },
    );
  }
}