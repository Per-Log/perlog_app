class DiaryModel {
  final String id;
  final String userId;
  final DateTime diaryDate;
  final String imageUrl;
  final String ocrText;
  final String? fontFamily;
  final DateTime createdAt;

  DiaryModel({
    required this.id,
    required this.userId,
    required this.diaryDate,
    required this.imageUrl,
    required this.ocrText,
    required this.fontFamily,
    required this.createdAt,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      diaryDate: DateTime.parse(json['diary_date'] as String),
      imageUrl: json['image_url'] as String,
      ocrText: json['ocr_text'] as String,
      fontFamily: json['font_family'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
