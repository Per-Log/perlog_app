import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';

class PinSetPage extends StatelessWidget {
  const PinSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PIN 설정')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('${Routes.onboarding}/${Routes.pinConfirm}');
          },
          child: const Text('PIN 입력 완료'),
        ),
      ),
    );
  }
}
