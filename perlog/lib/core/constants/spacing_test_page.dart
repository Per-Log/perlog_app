import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/widgets/bottom_button.dart';

class PaddingTestPage extends StatelessWidget {
  const PaddingTestPage({super.key});

  Widget _label(String text) {
    return Text(
      text,
      style: AppTextStyles.body18.copyWith(
        color: AppColors.mainFont,
      ),
    );
  }

  Widget _box(String label, double height) {
    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.subBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Spacing Test'),
      ),
      body: Padding(
        padding: AppSpacing.screen(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('small spacing'),
            SizedBox(height: AppSpacing.small(context)),
            _box(
              'height = small(${AppSpacing.small(context).toStringAsFixed(1)})',
              AppSpacing.small(context),
            ),

            SizedBox(height: AppSpacing.section(context)),

            _label('section spacing'),
            SizedBox(height: AppSpacing.section(context)),
            _box(
              'height = section(${AppSpacing.section(context).toStringAsFixed(1)})',
              AppSpacing.section(context),
            ),

            SizedBox(height: AppSpacing.section(context)),

            _label('large spacing'),
            SizedBox(height: AppSpacing.large(context)),
            _box(
              'height = large(${AppSpacing.large(context).toStringAsFixed(1)})',
              AppSpacing.large(context),
            ),

            SizedBox(height: AppSpacing.section(context)),

            _label('card padding'),
            Container(
              width: double.infinity,
              padding: AppSpacing.card,
              decoration: BoxDecoration(
                color: AppColors.subBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('card padding 적용됨'),
            ),

            const Spacer(),
          ],
        ),
      ),

      /// Bottom Button 영역 테스트
      bottomNavigationBar: Padding(
        padding: AppSpacing.bottomButtonPadding(context),
        child: BottomButton(
          text: '시작하기',
          enabled: true,
          onPressed: () {},
          backgroundColor: AppColors.background,
          borderColor: AppColors.subBackground,
          textColor: AppColors.mainFont,
        ),
      ),
    );
  }
}
