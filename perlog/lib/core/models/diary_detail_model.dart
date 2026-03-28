import 'diary_model.dart';
import 'diary_analysis_model.dart';

class DiaryDetailModel {
  final DiaryModel diary;
  final DiaryAnalysisModel? analysis;

  DiaryDetailModel({required this.diary, required this.analysis});
}
