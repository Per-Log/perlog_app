class ProfileModel {
  final String id;
  final String nickname;
  final String? profileImageUrl;
  final String? pinCode;
  final bool isLockEnabled;
  final bool isNotiEnabled;
  final String? notiTime;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.nickname,
    required this.profileImageUrl,
    required this.pinCode,
    required this.isLockEnabled,
    required this.isNotiEnabled,
    required this.notiTime,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      pinCode: json['pin_code'] as String?,
      isLockEnabled: json['is_lock_enabled'] as bool? ?? false,
      isNotiEnabled: json['is_noti_enabled'] as bool? ?? false,
      notiTime: json['noti_time']?.toString(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
