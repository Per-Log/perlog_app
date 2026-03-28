import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 1. 서버 주소 설정
  // 안드로이드 에뮬레이터: 10.0.2.2
  // iOS 시뮬레이터: localhost
  // 실제 기기: 내 컴퓨터의 IP 주소 (예: 192.168.0.x)
  static const String baseUrl = "http://10.0.2.2:8000/analyze";

  Future<Map<String, dynamic>> analyzeDiary(String content) async {
    try {
      // 2. POST 요청 보내기
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "user_input_data": content, // 파이썬 서버의 DiaryRequest 모델과 이름이 같아야 함
        }),
      );

      // 3. 응답 처리
      if (response.statusCode == 200) {
        // 서버에서 보낸 한글 데이터가 깨지지 않도록 utf8.decode 사용
        final String decodedBody = utf8.decode(response.bodyBytes);
        return jsonDecode(decodedBody);
      } else {
        print("서버 에러 상태 코드: ${response.statusCode}");
        return {"error": "서버 응답 오류 (Status: ${response.statusCode})"};
      }
    } catch (e) {
      print("네트워크 통신 중 에러 발생: $e");
      return {"error": "서버에 연결할 수 없습니다. 서버가 켜져 있는지 확인하세요."};
    }
  }
}
