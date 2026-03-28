import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/features/onboarding/widgets/pin_entry_content.dart';
import 'package:perlog/domain/lock/lock_service.dart';

class PinConfirmPage extends StatelessWidget {
  const PinConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final originalPin = GoRouterState.of(context).extra as String;

    return PinEntryContent(
      title: '한 번 더 입력해주세요.',
      buttonText: '변경 완료',

      onBack: () {
        context.pop(false);
      },

      onSubmit: (confirmPin) async {
        if (confirmPin != originalPin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
          );
          return;
        }
        
        await LockService.setPin(confirmPin);

        if (!context.mounted) return;
        context.pop(true);
      },
    );
  }
}