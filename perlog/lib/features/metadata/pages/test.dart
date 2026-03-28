import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

// --- [📡 1. API 서비스 클래스] ---
class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/analyze"; // 에뮬레이터 주소

  Future<Map<String, dynamic>> analyzeDiary(String content) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_input_data": content}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception("서버 응답 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ 연결 에러: $e");
      return {"error": "서버 연결 실패"};
    }
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _DiaryAnalysisState();
}

class _DiaryAnalysisState extends State<Test> {
  // 입력 제어를 위한 컨트롤러
  final TextEditingController _diaryController = TextEditingController();

  // 실시간 분석을 위한 데이터 변수
  String _targetContent = "";
  Map<String, String> _chartColors = {};

  // 초기 색상 로드
  Future<void> _loadColors() async {
    if (_chartColors.isEmpty) {
      final colorJson = await rootBundle.loadString('data/chart_color.json');
      _chartColors = Map<String, String>.from(json.decode(colorJson));
    }
  }

  // 헬퍼 함수들
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
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          "오늘의 기록 분석",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- [✍️ 입력 구역] ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _diaryController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "오늘 하루는 어땠나요? 일기를 써보세요.",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_diaryController.text.trim().isEmpty) return;
                        // 🔥 버튼을 누르면 입력값을 타겟으로 설정하고 화면을 갱신합니다.
                        setState(() {
                          _targetContent = _diaryController.text;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "AI 심리 분석 시작",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 1),

            // --- [📊 결과 구역] ---
            Expanded(
              child: _targetContent.isEmpty
                  ? const Center(child: Text("일기를 입력하고 분석 버튼을 눌러주세요!"))
                  : FutureBuilder<Map<String, dynamic>>(
                      // 버튼을 눌러 _targetContent가 바뀔 때마다 서버를 호출합니다.
                      future: Future.wait([
                        _loadColors(),
                        ApiService().analyzeDiary(_targetContent),
                      ]).then((value) => value[1] as Map<String, dynamic>),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError ||
                            snapshot.data!.containsKey('error')) {
                          return const Center(
                            child: Text('서버 연결 실패. FastAPI 서버를 켜주세요!'),
                          );
                        }

                        final current = snapshot.data!;
                        return _buildAnalysisResult(current);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- [🖼️ 분석 결과 UI 위젯] ---
  Widget _buildAnalysisResult(Map<String, dynamic> data) {
    final List<String> tags = List<String>.from(data['tags'] ?? []);
    final List emotions = data['emotions'] ?? [];
    final String scent = data['scent'] ?? "Woody";
    final String colorHex = data['color'] ?? "#EDCC77";
    final String scentMsg = data['scent_message'] ?? "";
    final String description = data['description'] ?? "";
    final mainColor = _hexToColor(colorHex);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 향기 & 설명 섹션
          Row(
            children: [
              Icon(Icons.wine_bar, size: 50, color: mainColor),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$scent${_getJosa(scent, "이", "가")} 어울리는 하루!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // 2. 태그 섹션
          Wrap(
            spacing: 8,
            children: tags
                .map(
                  (t) =>
                      Chip(label: Text("#$t"), backgroundColor: Colors.white),
                )
                .toList(),
          ),
          const SizedBox(height: 25),

          // 3. 메시지 카드 (실시간 메시지 반영)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: mainColor.withOpacity(0.3)),
            ),
            child: Text(
              scentMsg,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 25),

          // 4. 감정 Bar 그래프 카드 (서버 데이터 기반)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "감정 분석 리스트",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ...emotions.map((e) {
                  double score = (e['score'] as num).toDouble();
                  return _buildLongEmotionBar(
                    e['label'],
                    score,
                    _getIndividualColor(e['label'], colorHex),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLongEmotionBar(String label, double score, Color barColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text("${(score * 100).toInt()}%"),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: score,
            backgroundColor: Colors.grey[100],
            color: barColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }
}
