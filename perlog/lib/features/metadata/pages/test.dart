import 'dart:convert'; // JSON 파싱용
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle용
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/core/models/analysis.dart';
import 'package:fl_chart/fl_chart.dart';

Widget buildPrettyBarChart(List<EmotionScore> emotions, Color mainColor) {
  return BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 1.0, // 100% 기준
      barGroups: emotions.asMap().entries.map((entry) {
        return BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY: entry.value.score,
              gradient: LinearGradient(
                colors: [mainColor.withOpacity(0.3), mainColor],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 20,
              borderRadius: BorderRadius.circular(6), // 둥근 모서리
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 1.0,
                color: Colors.grey.withOpacity(0.1), // 배경 회색 바
              ),
            ),
          ],
        );
      }).toList(),
      // 격자 및 테두리 설정 생략...
      titlesData: FlTitlesData(show: false),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
    ),
  );
}
// ... 상단 import 생략 ...

// ... 상단 import 생략 ...

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _DiaryAnalysisState();
}

// ... 기존 import 유지 ...

// ... 상단 import 및 buildPrettyBarChart 함수 생략 (기존과 동일) ...

class _DiaryAnalysisState extends State<Test> {
  Map<String, String> _chartColors = {};

  Future<EmotionReport> _loadAnalysisData() async {
    final results = await Future.wait([
      rootBundle.loadString('data/chart_color.json'),
      rootBundle.loadString('data/diary_emotions.json'),
    ]);

    _chartColors = Map<String, String>.from(json.decode(results[0]));
    final List<dynamic> data = json.decode(results[1]);
    return EmotionReport.fromJson(data.last);
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  Color _getIndividualColor(String label, String defaultHex) {
    final hex = _chartColors[label] ?? defaultHex;
    return _hexToColor(hex);
  }

  Widget _buildDonutChart(List<EmotionScore> emotions, String defaultHex) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 45,
          sections: emotions.map((e) {
            return PieChartSectionData(
              color: _getIndividualColor(e.label, defaultHex),
              value: e.score,
              radius: 45,
              title: '',
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<EmotionReport>(
          future: _loadAnalysisData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
            }
            final report = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenPadding.left,
                  screenPadding.top,
                  screenPadding.right,
                  screenPadding.bottom + 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. 인사말 영역
                    Text(
                      '오늘의 기록,',
                      style: AppTextStyles.body16.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '퍼로그님의 하루예요.',
                      style: AppTextStyles.body22.copyWith(
                        color: AppColors.mainFont,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 2. 향수 설명 영역
                    Row(
                      children: [
                        const SizedBox(width: 24),
                        Image.asset(
                          'assets/icons/perfume.png',
                          height: 52,
                          width: 52,
                          color: _hexToColor(report.color),
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.wine_bar,
                            size: 52,
                            color: _hexToColor(report.color),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${report.scent}가 어울리는 하루였군요!',
                                style: AppTextStyles.body18SemiBold.copyWith(
                                  color: AppColors.mainFont,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                report.description,
                                style: AppTextStyles.body12.copyWith(
                                  color: AppColors.mainFont,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 3. 해시태그 바
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.subBackground,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: report.tags
                            .map(
                              (tag) => Text(
                                tag,
                                style: AppTextStyles.body18SemiBold.copyWith(
                                  color: AppColors.mainFont,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // [수정] 파이 차트 영역 (해시태그 아래로 이동)
                    Center(
                      child: _buildDonutChart(report.emotions, report.color),
                    ),

                    const SizedBox(height: 32),

                    // 4. 메인 분석 결과 카드
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.subBackground,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '감정 분석 결과',
                            style: AppTextStyles.body18SemiBold.copyWith(
                              color: AppColors.mainFont,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ...report.emotions.map(
                            (emotion) => _buildEmotionBar(
                              emotion.label,
                              emotion.score,
                              _getIndividualColor(emotion.label, report.color),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 5. 하단 버튼
                    BottomButton(
                      text: '홈으로',
                      onPressed: () => context.go(Routes.home),
                      enabled: true,
                      backgroundColor: AppColors.background,
                      borderColor: AppColors.mainFont,
                      textColor: AppColors.mainFont,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmotionBar(String label, double score, Color barColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.body18SemiBold.copyWith(
                  color: AppColors.mainFont,
                ),
              ),
              Text(
                '${(score * 100).toInt()}%',
                style: AppTextStyles.body14.copyWith(color: AppColors.mainFont),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: score,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
