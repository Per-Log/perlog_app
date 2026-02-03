import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/features/onboarding/widgets/pin_entry_content.dart';
import '../../../core/router/routes.dart';

class PinConfirmPage extends StatelessWidget {
  const PinConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PinEntryContent(
      title: '한 번 더 입력해주세요.',
      buttonText: '확인 완료',
      onBack: () {
        context.go('${Routes.onboarding}/${Routes.pinSet}');
      },
      onSubmit: () {
        context.go(Routes.shell);
      },
    );
  }
}
