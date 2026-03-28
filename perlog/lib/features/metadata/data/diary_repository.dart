import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:perlog/core/models/profile_model.dart';
import 'package:perlog/core/models/diary_model.dart';
import 'package:perlog/core/models/diary_analysis_model.dart';
import 'package:perlog/core/models/diary_detail_model.dart';

class DiaryRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<ProfileModel?> fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return ProfileModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<List<DiaryModel>> fetchDiariesByUser(String userId) async {
    final data = await _client
        .from('diaries')
        .select()
        .eq('user_id', userId)
        .order('diary_date', ascending: false);

    return (data as List)
        .map((e) => DiaryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<DiaryAnalysisModel?> fetchAnalysisByDiaryId(String diaryId) async {
    final data = await _client
        .from('diary_analysis')
        .select()
        .eq('diary_id', diaryId)
        .maybeSingle();

    if (data == null) return null;
    return DiaryAnalysisModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<DiaryDetailModel?> fetchDiaryDetailByDate({
    required String userId,
    required DateTime date,
  }) async {
    final dateString = date.toIso8601String().split('T').first;

    final diaryJson = await _client
        .from('diaries')
        .select()
        .eq('user_id', userId)
        .eq('diary_date', dateString)
        .maybeSingle();

    if (diaryJson == null) return null;

    final diary = DiaryModel.fromJson(Map<String, dynamic>.from(diaryJson));
    final analysis = await fetchAnalysisByDiaryId(diary.id);

    return DiaryDetailModel(diary: diary, analysis: analysis);
  }
}
