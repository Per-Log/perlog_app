class DiaryEmotionScore {
  final String label;
  final double score;

  DiaryEmotionScore({required this.label, required this.score});

  factory DiaryEmotionScore.fromJson(Map<String, dynamic> json) {
    return DiaryEmotionScore(
      label: json['label'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }
}

class DiaryAnalysisModel {
  final String diaryId;
  final String summary;
  final String topEmotion;
  final String scent;
  final String description;
  final String color;
  final List<String> tags;
  final List<DiaryEmotionScore> emotionsScore;

  DiaryAnalysisModel({
    required this.diaryId,
    required this.summary,
    required this.topEmotion,
    required this.scent,
    required this.description,
    required this.color,
    required this.tags,
    required this.emotionsScore,
  });

  factory DiaryAnalysisModel.fromJson(Map<String, dynamic> json) {
    final rawScores = (json['emotions_score'] as List<dynamic>? ?? []);
    return DiaryAnalysisModel(
      diaryId: json['diary_id'] as String,
      summary: json['summary'] as String,
      topEmotion: json['top_emotion'] as String,
      scent: json['scent'] as String,
      description: json['description'] as String,
      color: json['color'] as String,
      tags: List<String>.from(json['tags'] ?? const []),
      emotionsScore: rawScores
          .map((e) => DiaryEmotionScore.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
