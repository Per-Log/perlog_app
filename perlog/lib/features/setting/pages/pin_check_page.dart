import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/onboarding/widgets/pin_entry_content.dart';

class PinCheckPage extends StatelessWidget {
  const PinCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PinEntryContent(
      title: '비밀번호를 입력해주세요.',
      buttonText: '확인',
      showBackButton: true,
      onSubmit: () {
        //TODO: PIN 검증 로직 연결
        context.push('${Routes.settings}/${Routes.settingsPinSet}');
      },
    );
  }
}
