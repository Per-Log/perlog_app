import 'package:supabase_flutter/supabase_flutter.dart';

class DiaryRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> insertProfile({
    required String id,
    required String nickname,
    String? profileImageUrl,
    String? pinCode,
    bool isLockEnabled = false,
    bool isNotiEnabled = false,
    String? notiTime,
  }) async {
    await _client.from('profiles').insert({
      'id': id,
      'nickname': nickname,
      'profile_image_url': profileImageUrl,
      'pin_code': pinCode,
      'is_lock_enabled': isLockEnabled,
      'is_noti_enabled': isNotiEnabled,
      'noti_time': notiTime,
    });
  }

  Future<void> insertDiary({
    required String id,
    required String userId,
    required DateTime diaryDate,
    required String imageUrl,
    required String ocrText,
    String? fontFamily,
  }) async {
    await _client.from('diaries').insert({
      'id': id,
      'user_id': userId,
      'diary_date': diaryDate.toIso8601String().split('T').first,
      'image_url': imageUrl,
      'ocr_text': ocrText,
      'font_family': fontFamily,
    });
  }

  Future<void> insertDiaryAnalysis({
    required String diaryId,
    required String summary,
    required String topEmotion,
    required String scent,
    required String description,
    required String color,
    required List<String> tags,
    required List<Map<String, dynamic>> emotionsScore,
  }) async {
    await _client.from('diary_analysis').insert({
      'diary_id': diaryId,
      'summary': summary,
      'top_emotion': topEmotion,
      'scent': scent,
      'description': description,
      'color': color,
      'tags': tags,
      'emotions_score': emotionsScore,
    });
  }
}
