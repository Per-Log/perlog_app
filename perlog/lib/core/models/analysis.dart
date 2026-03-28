class EmotionReport {
  final String text;
  final String topEmotion;
  final String scent;
  final String description;
  final String color;
  final List<String> tags;
  final List<EmotionScore> emotions;

  EmotionReport({
    required this.text,
    required this.topEmotion,
    required this.scent,
    required this.description,
    required this.color,
    required this.tags,
    required this.emotions,
  });

  factory EmotionReport.fromJson(Map<String, dynamic> json) {
    return EmotionReport(
      text: json['text'],
      topEmotion: json['top_emotion'],
      scent: json['scent'],
      description: json['description'],
      color: json['color'],
      tags: List<String>.from(json['tags']),
      emotions: (json['emotions'] as List)
          .map((e) => EmotionScore.fromJson(e))
          .toList(),
    );
  }
}

class EmotionScore {
  final String label;
  final double score;

  EmotionScore({required this.label, required this.score});

  factory EmotionScore.fromJson(Map<String, dynamic> json) {
    return EmotionScore(
      label: json['label'],
      score: (json['score'] as num).toDouble(),
    );
  }
}
