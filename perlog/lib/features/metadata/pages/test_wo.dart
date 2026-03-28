import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/widgets/bottom_button.dart';
import 'package:perlog/core/models/analysis.dart';
import 'package:fl_chart/fl_chart.dart';

class TestWo extends StatefulWidget {
  final String diaryText;
  const TestWo({super.key, this.diaryText = "오늘은 정말 행복한 하루였어!"});

  @override
  State<TestWo> createState() => _DiaryAnalysisState();
}

class _DiaryAnalysisState extends State<TestWo> {
  Map<String, dynamic> _mappedData = {};

  // --- [핵심: Gemini 분석 결과를 받아서 Flutter 로컬 데이터와 결합] ---
  Future<Map<String, dynamic>> _loadAnalysisFromServer() async {
    // 1. 로컬 설정 데이터 로드 (색상/향수 매핑 테이블)
    final mappingJson = await rootBundle.loadString('data/mapped.json');
    _mappedData = json.decode(mappingJson);

    // 2. FastAPI 서버 호출
    final url = Uri.parse('http://localhost:8000/analyze');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_input_data': widget.diaryText}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        // [Gemini 데이터 추출]
        final String topEmotionLabel =
            data['emotions'][0]['label']; // Gemini가 뽑은 1순위 감정
        final String description = data['description'] ?? ""; // Gemini의 공감 문구
        final List<String> tags = List<String>.from(data['tags'] ?? []);

        // [로컬 매핑 데이터 적용]
        // Gemini가 준 감정 이름을 key로 사용하여 로컬의 색상과 향수 이름을 가져옴
        final String mappedColor =
            _mappedData[topEmotionLabel]?['color'] ?? "#FFFFFF";
        final String mappedScent =
            _mappedData[topEmotionLabel]?['scent'] ?? "Unknown Scent";

        final emotionsList = data['emotions'] as List;

        final current = EmotionReport(
          text: widget.diaryText, // 추가: 원문 텍스트
          topEmotion: topEmotionLabel, // 추가: 1순위 감정명
          scent: data['scent'] ?? "Unknown",
          color: data['color'] ?? "#FFFFFF",
          description: data['description'] ?? "",
          tags: List<String>.from(data['tags'] ?? []),
          emotions: emotionsList
              .map(
                (e) => EmotionScore(
                  label: e['label'],
                  score: (e['score'] as num).toDouble(),
                ),
              )
              .toList(),
        );

        // 과거 히스토리 데이터 (나의 성장 과정용)
        final historyJson = await rootBundle.loadString(
          'data/diary_emotions.json',
        );
        final List<dynamic> historyData = json.decode(historyJson);
        final previous = historyData.isNotEmpty
            ? EmotionReport.fromJson(historyData.last)
            : null;

        return {"current": current, "previous": previous};
      } else {
        throw Exception('서버 응답 오류');
      }
    } catch (e) {
      debugPrint("분석 에러: $e");
      rethrow;
    }
  }

  Color _hexToColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xff')));

  // 감정별 지정된 색상 가져오기
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
          future: _loadAnalysisFromServer(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('서버와 통신할 수 없습니다.\nPython 서버가 켜져있는지 확인해주세요.'),
              );
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

                        // 향수 영역: Gemini가 분석한 내용 + 매칭된 향수 이름
                        _buildScentSection(current, mainReportColor),
                        const SizedBox(height: 32),

                        // 태그 영역: Gemini가 뽑은 키워드
                        _buildTagBar(current.tags),
                        const SizedBox(height: 32),

                        // 도넛 차트
                        Center(
                          child: _buildDonutChart(
                            current.emotions,
                            current.color,
                            mainReportColor,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 메인 분석 카드 (감정 점수 바)
                        _buildMainAnalysisCard(
                          current,
                          previous,
                          mainReportColor,
                        ),
                        const SizedBox(height: 20),

                        // 전체 감정 상세 기록
                        _buildAllEmotionsCard(current),
                      ],
                    ),
                  ),
                ),
                _buildBottomButton(context, screenPadding),
              ],
            );
          },
        ),
      ),
    );
  }

  // 상단 향수 섹션 위젯
  Widget _buildScentSection(EmotionReport current, Color mainColor) {
    return Row(
      children: [
        const SizedBox(width: 24),
        Image.asset(
          'assets/icons/perfume.png',
          height: 52,
          width: 52,
          color: mainColor,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.wine_bar, size: 52, color: mainColor),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${current.scent} 향이 어울리는 하루였군요!',
                style: AppTextStyles.body18SemiBold.copyWith(
                  color: AppColors.mainFont,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                current.description,
                style: AppTextStyles.body12.copyWith(color: AppColors.mainFont),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- [차트 및 UI 위젯들은 기존 로직 유지] ---
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
            curve: Curves.easeOutQuart,
            builder: (context, value, child) {
              return Stack(
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            barColor.withOpacity(0.6),
                            barColor,
                            barColor.withOpacity(0.8),
                          ],
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
            .map((t) => Text(t, style: AppTextStyles.body18SemiBold))
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
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              sections: emotions
                  .map(
                    (e) => PieChartSectionData(
                      color: _getEmotionMappedColor(e.label, defaultHex),
                      value: e.score,
                      radius: 25,
                      title: '',
                    ),
                  )
                  .toList(),
            ),
          ),
          Icon(Icons.auto_awesome, color: mainColor, size: 28),
        ],
      ),
    );
  }

  Widget _buildMainAnalysisCard(
    EmotionReport report,
    EmotionReport? previous,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('감정 분석 결과', style: AppTextStyles.body18SemiBold),
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
    final activeEmotions = report.emotions.where((e) => e.score > 0).toList();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('상세 기록', style: AppTextStyles.body18SemiBold),
          const SizedBox(height: 24),
          ...activeEmotions.map(
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

  Widget _buildBottomButton(BuildContext context, EdgeInsets padding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.horizontal,
        0,
        AppSpacing.horizontal,
        padding.bottom + 10,
      ),
      child: BottomButton(
        text: '홈으로',
        onPressed: () => context.go(Routes.home),
        enabled: true,
        backgroundColor: AppColors.subBackground,
        borderColor: AppColors.subBackground,
        textColor: AppColors.mainFont,
      ),
    );
  }
}
