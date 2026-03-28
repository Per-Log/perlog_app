import 'package:perlog/core/storage/pref/pref_keys.dart';
import 'package:perlog/core/storage/pref/pref_service.dart';
import 'package:perlog/core/models/notification_period.dart';

class OnboardingService {
  OnboardingService._();

  // 프로필 완료 여부
  static Future<bool> isProfileCompleted() async {
    return await PrefService.getBoolOrDefault(
      PrefKeys.profileCompleted,
      false,
    );
  }

  static Future<void> setProfileCompleted(bool value) async {
    await PrefService.setBool(PrefKeys.profileCompleted, value);
  }

  // 닉네임 관련
  static Future<void> setNickname(String nickname) async {
    await PrefService.setString(
      PrefKeys.nickname,
      nickname.trim(),
    );
  }

  static Future<String?> getNickname() async {
    return await PrefService.getString(PrefKeys.nickname);
  }

  // 프로필 이미지 관련
  static Future<void> setProfileImageUrl(String url) async {
    await PrefService.setString(PrefKeys.profileImageUrl, url);
  }

  static Future<String?> getProfileImageUrl() async {
    return await PrefService.getString(PrefKeys.profileImageUrl);
  }

  // 알림 관련
  static Future<void> setNotificationEnabled(bool enabled) async {
    await PrefService.setBool(PrefKeys.alarmEnabled, enabled);
  }

  static Future<bool> isNotificationEnabled() async {
    return await PrefService.getBoolOrDefault(
      PrefKeys.alarmEnabled,
      false,
    );
  }

  static Future<void> setNotificationPeriod(
    NotificationPeriod period,
  ) async {
    await PrefService.setInt(
      PrefKeys.alarmInterval,
      period.days,
    );
  }

  static Future<NotificationPeriod> getNotificationPeriod() async {
    final days = await PrefService.getInt(PrefKeys.alarmInterval);

    if (days == null) {
      return NotificationPeriod.threeDays;
    }

    return NotificationPeriodX.fromDays(days);
  }

  // 온보딩 완료 처리
  static Future<void> completeOnboarding({
    required String nickname,
    required bool notificationEnabled,
    required NotificationPeriod period,
    String? profileImageUrl,
  }) async {
    await setNickname(nickname);
    await setNotificationEnabled(notificationEnabled);
    await setNotificationPeriod(period);

    if (profileImageUrl != null) {
      await setProfileImageUrl(profileImageUrl);
    }

    await setProfileCompleted(true);
  }
}