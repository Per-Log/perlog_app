import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/features/onboarding/pages/widgets/pin_entry_content.dart';
import '../../../core/router/routes.dart';

class PinSetPage extends StatelessWidget {
  const PinSetPage({super.key});

  @override
  Widget build(BuildContext context) {
        return PinEntryContent(
      title: '비밀번호를 입력해주세요.',
      buttonText: '입력 확인',
      onBack: () {
        context.go('${Routes.onboarding}/${Routes.profile}');
      },
      onSubmit: () {
        context.go('${Routes.onboarding}/${Routes.pinConfirm}');
      },
    );
  }
}