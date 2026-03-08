import 'package:supabase_flutter/supabase_flutter.dart';

/// NOTE:
/// API 키를 앱에 직접 넣으면 탈취될 수 있으므로,
/// OCR은 Supabase Edge Function(서버)에서 Google Vision API를 호출합니다.
/// 앱은 공개 가능한 Supabase anon key로 함수만 호출합니다.
class GoogleVisionOcrService {
  GoogleVisionOcrService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<String?> extractTextFromImageUrl(String imageUrl) async {
    final response = await _client.functions.invoke(
      'google-vision-ocr',
      body: {'imageUrl': imageUrl},
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final text = data['text'];
      if (text is String && text.trim().isNotEmpty) {
        return text.trim();
      }
    }

    return null;
  }
}
