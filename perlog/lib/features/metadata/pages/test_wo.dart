import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

// --- [📡 API 서비스: 다인님의 FastAPI 서버용] ---
class ApiService {
  // 안드로이드 에뮬레이터에서 내 컴퓨터 서버에 접속하는 주소
  static const String baseUrl = "http://10.0.2.2:8000/analyze";

  Future<Map<String, dynamic>> analyzeDiary(String content) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_input_data": content}),
      );

      if (response.statusCode == 200) {
        // 서버 응답(UTF-8)을 디코딩하여 JSON으로 변환
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception("서버 응답 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ 연결 에러: $e");
      return {"error": "서버 연결에 실패했습니다."};
    }
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _DiaryAnalysisState();
}

class _DiaryAnalysisState extends State<Test> {
  Map<String, String> _chartColors = {};

  // 💡 [중요] 이전 화면에서 넘겨받아야 할 일기 내용 (지금은 테스트용)
  final String _inputDiary = "오늘 친구랑 맛있는 거 먹고 산책했는데 정말 행복하고 안심되는 하루였어.";

  // 1. 데이터 로드 로직 (다인님의 서버 데이터 구조에 맞춤)
  Future<Map<String, dynamic>> _loadAnalysisData() async {
    // chart_color.json 로드 (기존 로직 유지)
    final colorJson = await rootBundle.loadString('data/chart_color.json');
    _chartColors = Map<String, String>.from(json.decode(colorJson));

    // 📡 실시간 서버 호출
    final result = await ApiService().analyzeDiary(_inputDiary);

    // 성장 그래프용 더미 이전 데이터 (실제 서비스 시 DB에서 불러와야 함)
    return {"current": result, "previous": null};
  }

  // --- [기존 유틸리티 함수 유지] ---
  String _getJosa(String word, String josa1, String josa2) {
    if (word.isEmpty) return josa1;
    int lastCode = word.codeUnitAt(word.length - 1);
    if (lastCode < 0xAC00 || lastCode > 0xD7A3) return josa1;
    return (lastCode - 0xAC00) % 28 > 0 ? josa1 : josa2;
  }

  Color _hexToColor(String hex) {
    if (hex.isEmpty) return Colors.grey;
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  Color _getIndividualColor(String label, String defaultHex) {
    final hex = _chartColors[label] ?? defaultHex;
    return _hexToColor(hex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // AppColors.background
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _loadAnalysisData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.containsKey('error')) {
              return const Center(
                child: Text('분석 데이터를 가져오지 못했습니다. 서버를 확인해주세요.'),
              );
            }

            // 서버 응답 데이터 매핑
            final current = snapshot.data!['current'];
            final List<String> tags = List<String>.from(current['tags'] ?? []);
            final List emotionsRaw = current['emotions'] ?? [];
            final String description = current['description'] ?? "";
            final String scent = current['scent'] ?? "Woody";
            final String colorHex = current['color'] ?? "#EDCC77";
            final String scentMsg = current['scent_message'] ?? "";

            final mainReportColor = _hexToColor(colorHex);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('오늘의 기록,', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        const Text(
                          '퍼로그님의 하루예요.',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 향수 영역 (서버 데이터 scent, description 연결)
                        Row(
                          children: [
                            const SizedBox(width: 24),
                            Icon(
                              Icons.wine_bar,
                              size: 52,
                              color: mainReportColor,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$scent${_getJosa(scent, "이", "가")} 어울리는 하루였군요!',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    description,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // 태그 바 (서버 데이터 tags 연결)
                        _buildTagBar(tags),
                        const SizedBox(height: 32),

                        // 도넛 차트 (서버 데이터 emotions 연결)
                        Center(
                          child: _buildDonutChart(
                            emotionsRaw,
                            colorHex,
                            mainReportColor,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 분석 결과 메시지 (scent_message 연결)
                        _buildMessageCard(scentMsg, mainReportColor),
                        const SizedBox(height: 20),

                        // 상세 감정 리스트 (emotions 연결)
                        _buildAllEmotionsCard(emotionsRaw, colorHex),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // 하단 버튼 (유지)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFEEEEEE)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '홈으로',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- [데이터 기반 위젯들] ---

  Widget _buildTagBar(List<String> tags) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF1F1F1),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        children: tags
            .map(
              (tag) => Text(
                "#$tag",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDonutChart(List emotions, String defaultHex, Color mainColor) {
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: emotions.map((e) {
            return PieChartSectionData(
              color: _getIndividualColor(e['label'], defaultHex),
              value: (e['score'] as num).toDouble(),
              radius: 25,
              title: '',
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMessageCard(String msg, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(msg, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }

  Widget _buildAllEmotionsCard(List emotions, String defaultHex) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '감정 분석 결과',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...emotions.map((e) {
            double score = (e['score'] as num).toDouble();
            return _buildLongEmotionBar(
              e['label'],
              score,
              _getIndividualColor(e['label'], defaultHex),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLongEmotionBar(String label, double score, Color barColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text(
                '${(score * 100).toInt()}%',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: score,
            backgroundColor: Colors.grey[100],
            color: barColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
