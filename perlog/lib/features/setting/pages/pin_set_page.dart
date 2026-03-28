import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/onboarding/widgets/pin_entry_content.dart';

class PinSetPage extends StatelessWidget {
  const PinSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PinEntryContent(
      title: '재설정할 비밀번호를 입력해주세요.',
      buttonText: '다음',
      showBackButton: true,

      onSubmit: (pin) async {
        final result = await context.push(
          '${Routes.settings}/${Routes.settingsPinConfirm}',
          extra: pin,
        );

        if (result == true) {
          if (!context.mounted) return;
          context.pop(true);
        }
      },
    );
  }
}