import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';

class PaddingTestPage extends StatelessWidget {
  const PaddingTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Padding Test'),
      ),

      /// bottomButton 패딩 테스트용 버튼
      bottomNavigationBar: Padding(
        padding: AppSpacing.bottomButton,
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Bottom Button (AppSpacing.bottomButton)'),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSpacing.screen,
              child: Container(
                height: 120,
                color: Colors.orange.withOpacity(0.35),
                child: const Center(
                  child: Text('AppSpacing.screen'),
                ),
              ),
            ),
            
            Padding(
              padding: AppSpacing.horizontalPadding,
              child: Container(
                height: 80,
                color: Colors.blue.withOpacity(0.35),
                child: const Center(
                  child: Text('AppSpacing.horizontalPadding'),
                ),
              ),
            ),

            Padding(
              padding: AppSpacing.horizontalPadding,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: AppSpacing.card,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Card Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '이 영역은 AppSpacing.card (16px) 패딩이 적용된 카드 내부 영역입니다.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: AppSpacing.horizontalPadding,
              child: Container(
                height: 1,
                color: Colors.red,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
