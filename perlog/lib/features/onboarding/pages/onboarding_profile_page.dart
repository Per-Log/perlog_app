import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';

class OnboardingProfilePage extends StatelessWidget {
  const OnboardingProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool lockEnabled = true; // 여기 바꾸면서 테스트

    return Scaffold(
      appBar: AppBar(title: const Text('프로필 설정')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('이미지 / 별명 / 알림 / 잠금 설정'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (lockEnabled) {
                  context.go('${Routes.onboarding}/${Routes.pinSet}');
                } else {
                  context.go(Routes.shell);
                }
              },
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
