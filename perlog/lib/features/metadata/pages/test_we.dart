import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/core/models/analysis.dart';
import 'package:fl_chart/fl_chart.dart';

class TestWe extends StatefulWidget {
  const TestWe({super.key});

  @override
  State<TestWe> createState() => _DiaryAnalysisState();
}

class _DiaryAnalysisState extends State<TestWe> {
  Map<String, String> _chartColors = {};
  Map<String, dynamic> _mappedData = {};

  final List<String> _orderedEmotionLabels = [
    "화남/분노",
    "증오/혐오",
    "짜증",
    "불평/불만",
    "어이없음",
    "공포/무서움",
    "불안/걱정",
    "의심/불신",
    "지긋지긋",
    "귀찮음",
    "슬픔",
    "서러움",
    "절망",
    "힘듦/지침",
    "패배/자기혐오",
    "신기함/관심",
    "깨달음",
    "없음",
    "편안/쾌적",
    "안심/신뢰",
    "고마움",
    "존경",
    "뿌듯함",
    "흐뭇함",
    "아껴주는",
    "부끄러움",
    "감동/감탄",
    "기대감",
    "즐거움/신남",
    "행복",
    "기쁨",
  ];

  Future<Map<String, dynamic>> _loadAnalysisData() async {
    final results = await Future.wait([
      rootBundle.loadString('data/chart_color.json'),
      rootBundle.loadString('data/diary_emotions.json'),
      rootBundle.loadString('data/mapped.json'),
    ]);

    _chartColors = Map<String, String>.from(json.decode(results[0]));
    final List<dynamic> emotionData = json.decode(results[1]);
    _mappedData = json.decode(results[2]);

    final current = EmotionReport.fromJson(emotionData.last);
    final previous = emotionData.length > 1
        ? EmotionReport.fromJson(emotionData[emotionData.length - 2])
        : null;

    return {"current": current, "previous": previous};
  }

  String _getJosa(String word, String josa1, String josa2) {
    if (word.isEmpty) return josa1;
    int lastCode = word.codeUnitAt(word.length - 1);
    if (lastCode < 0xAC00 || lastCode > 0xD7A3) return josa1;
    return (lastCode - 0xAC00) % 28 > 0 ? josa1 : josa2;
  }

  String _getGrowthComment(EmotionReport current, EmotionReport? previous) {
    if (previous == null) return "첫 번째 기록이네요! 앞으로의 변화를 기대해 주세요.";
    double currentJoy = current.emotions
        .firstWhere(
          (e) => e.label == '기쁨',
          orElse: () => EmotionScore(label: '기쁨', score: 0),
        )
        .score;
    double prevJoy = previous.emotions
        .firstWhere(
          (e) => e.label == '기쁨',
          orElse: () => EmotionScore(label: '기쁨', score: 0),
        )
        .score;

    if (currentJoy > prevJoy + 0.05) return "지난 기록보다 긍정적인 감정 선이 부드럽게 상승하고 있어요.";
    if (currentJoy < prevJoy - 0.05)
      return "오늘은 조금 가라앉은 기분이지만, 내일은 다시 피어날 거예요.";
    return "평온한 감정 상태가 아주 잘 유지되고 있네요!";
  }

  Color _hexToColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xff')));

  Color _getEmotionMappedColor(String label, String defaultHex) {
    if (_mappedData.containsKey(label)) {
      return _hexToColor(_mappedData[label]['color']);
    }
    return _hexToColor(defaultHex);
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _loadAnalysisData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
            }

            final current = snapshot.data!['current'] as EmotionReport;
            final previous = snapshot.data!['previous'] as EmotionReport?;
            final mainReportColor = _hexToColor(current.color);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      screenPadding.left,
                      screenPadding.top,
                      screenPadding.right,
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                        // 향수 영역
                        Row(
                          children: [
                            const SizedBox(width: 24),
                            Image.asset(
                              'assets/icons/perfume.png',
                              height: 52,
                              width: 52,
                              color: mainReportColor,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.wine_bar,
                                    size: 52,
                                    color: mainReportColor,
                                  ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${current.scent}${_getJosa(current.scent, "이", "가")} 어울리는 하루였군요!',
                                    style: AppTextStyles.body18SemiBold
                                        .copyWith(color: AppColors.mainFont),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    current.description,
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

                        _buildTagBar(current.tags),
                        const SizedBox(height: 32),

                        Center(
                          child: _buildDonutChart(
                            current.emotions,
                            current.color,
                            mainReportColor,
                          ),
                        ),
                        const SizedBox(height: 32),

                        _buildMainAnalysisCard(
                          current,
                          previous,
                          mainReportColor,
                        ),
                        const SizedBox(height: 20),

                        _buildAllEmotionsCard(current),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.horizontal,
                    0,
                    AppSpacing.horizontal,
                    screenPadding.bottom + 10,
                  ),
                  child: BottomButton(
                    text: '홈으로',
                    onPressed: () => context.go(Routes.home),
                    enabled: true,
                    backgroundColor: AppColors.subBackground,
                    borderColor: AppColors.subBackground,
                    textColor: AppColors.mainFont,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- 입체감(3D)과 애니메이션이 적용된 바 차트 ---
  Widget _buildLongEmotionBar(String label, double score, Color barColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.body14.copyWith(color: AppColors.mainFont),
              ),
              Text(
                '${(score * 100).toInt()}%',
                style: AppTextStyles.body12.copyWith(color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: score),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart, // 자연스럽게 감속하며 차오르는 효과
            builder: (context, value, child) {
              return Stack(
                children: [
                  // 배경 트랙 (그림자 효과로 깊이감 부여)
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // 실제 채워지는 3D 바
                  FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // 세로 그라데이션으로 원통형 입체감 구현
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            barColor.withOpacity(0.6), // 상단 하이라이트
                            barColor, // 본체 색상
                            barColor.withOpacity(0.8), // 하단 그림자
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: barColor.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      // 하단에 살짝 광택을 더함
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainAnalysisCard(
    EmotionReport report,
    EmotionReport? previous,
    Color mainColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('나의 성장 과정', style: AppTextStyles.body18SemiBold),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGrowthLineChart(mainColor)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _getGrowthComment(report, previous),
                  style: AppTextStyles.body12.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(thickness: 0.5),
          ),
          Center(child: Text('감정 분석 결과', style: AppTextStyles.body18SemiBold)),
          const SizedBox(height: 24),
          ...report.emotions.map(
            (e) => _buildLongEmotionBar(
              e.label,
              e.score,
              _getEmotionMappedColor(e.label, report.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllEmotionsCard(EmotionReport report) {
    final sortedEmotions = _orderedEmotionLabels
        .map(
          (label) => report.emotions.firstWhere(
            (e) => e.label == label,
            orElse: () => EmotionScore(label: label, score: 0.0),
          ),
        )
        .where((e) => e.score > 0)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('상세 감정 기록', style: AppTextStyles.body18SemiBold),
          const SizedBox(height: 24),
          ...sortedEmotions.map(
            (e) => _buildLongEmotionBar(
              e.label,
              e.score,
              _getEmotionMappedColor(e.label, report.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagBar(List<String> tags) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.subBackground,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: tags
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
    );
  }

  Widget _buildDonutChart(
    List<EmotionScore> emotions,
    String defaultHex,
    Color mainColor,
  ) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 55,
              sections: emotions
                  .map(
                    (e) => PieChartSectionData(
                      color: _getEmotionMappedColor(e.label, defaultHex),
                      value: e.score,
                      radius: 30,
                      title: '',
                    ),
                  )
                  .toList(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: mainColor, size: 24),
              const SizedBox(height: 4),
              Text(
                '감정 밸런스',
                style: AppTextStyles.body12.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthLineChart(Color color) {
    return SizedBox(
      height: 80,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: color.withOpacity(0.5),
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.2), color.withOpacity(0)],
                ),
              ),
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 1.4),
                FlSpot(2, 1.1),
                FlSpot(3, 2.2),
                FlSpot(4, 2.5),
                FlSpot(5, 3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
