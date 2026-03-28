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

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _DiaryAnalysisState();
}

class _DiaryAnalysisState extends State<Test> {
  // JSON 데이터를 불러오는 함수
  Future<EmotionReport> _loadAnalysisData() async {
    final String response = await rootBundle.loadString(
      'data/diary_emotions.json',
    );
    final List<dynamic> data = json.decode(response);
    // 예시로 가장 최근(마지막) 분석 데이터를 가져옴
    return EmotionReport.fromJson(data.last);
  }

  // 헥사 코드를 Color로 변환하는 헬퍼 함수
  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<EmotionReport>(
          future: _loadAnalysisData(), // 데이터 로드 시작
          builder: (context, snapshot) {
            // 로딩 중일 때
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // 에러 발생 시
            if (snapshot.hasError) {
              return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
            }
            // 데이터 로드 완료 시
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
                    // 1. 날짜 (JSON 데이터 활용 가능)
                    Text(
                      '오늘의 기록,', // 날짜 데이터가 있다면 report.date 등으로 교체
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

                    // 2. 향수 설명 영역 (JSON 데이터 적용)
                    Row(
                      children: [
                        const SizedBox(width: 24),
                        Image.asset(
                          'assets/icons/perfume.png',
                          height: 52,
                          width: 52,
                          color: _hexToColor(report.color), // 분석된 감정 색상 적용
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
                                '${report.scent}가???? 어울리는 하루였군요!',
                                style: AppTextStyles.body18SemiBold.copyWith(
                                  color: AppColors.mainFont,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                report.description, // Python에서 보낸 랜덤 워딩
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

                    // 3. 해시태그 바 (JSON의 tags 리스트 활용)
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
                                  color: AppColors.mainFont, // 강조색 적용
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 4. 메인 분석 결과 카드 (감정 그래프 구현)
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
                          const SizedBox(height: 20),
                          // 감정 리스트를 반복문으로 그래프 생성
                          ...report.emotions.map(
                            (emotion) => _buildEmotionBar(
                              emotion.label,
                              emotion.score,
                              report.color,
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

  // 감정 그래프 위젯 분리
  Widget _buildEmotionBar(String label, double score, String hexColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.body12),
              Text('${(score * 100).toInt()}%', style: AppTextStyles.body12),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: score,
              minHeight: 12,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(_hexToColor(hexColor)),
            ),
          ),
        ],
      ),
    );
  }
}
