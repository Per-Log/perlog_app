import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';

class PinConfirmPage extends StatelessWidget {
  const PinConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PIN 확인')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go(Routes.shell);
          },
          child: const Text('PIN 확인 완료'),
        ),
      ),
    );
  }
}
