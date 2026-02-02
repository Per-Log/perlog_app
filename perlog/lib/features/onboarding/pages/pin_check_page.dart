import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/features/onboarding/pages/widgets/pin_entry_content.dart';
import '../../../core/router/routes.dart';

class PinCheckPage extends StatelessWidget {
  const PinCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PinEntryContent(
      title: 'PIN을 입력해주세요.',
      buttonText: '확인',
      onSubmit: () {
        // TODO: PIN 검증 로직 연결
        context.go(Routes.shell);
      },
    );
  }
}
