import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/onboarding/widgets/pin_entry_content.dart';

class PinConfirmPage extends StatelessWidget {
  const PinConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PinEntryContent(
      title: '한 번 더 입력해주세요.',
      buttonText: '변경 완료',
      onBack: () {
        context.pop();
      },
      onSubmit: () {
        context.go(Routes.settings);
      },
    );
  }
}