import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:perlog/core/storage/pref/pref_keys.dart';
import 'package:perlog/core/storage/pref/pref_service.dart';
import 'package:perlog/core/models/notification_period.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    required bool lockEnabled, // 추가: DB 저장을 위해 필요
    String? pinCode, // 추가: DB 저장을 위해 필요
  }) async {
    // 1. 기존 로컬 저장 (SharedPrefs)
    await setNickname(nickname);
    await setNotificationEnabled(notificationEnabled);
    await setNotificationPeriod(period);
    if (profileImageUrl != null) {
      await setProfileImageUrl(profileImageUrl);
    }
    await setProfileCompleted(true);

    // 2. Supabase DB에 저장
    try {
      final supabase = Supabase.instance.client;
      //final userId = supabase.auth.currentUser?.id; // 현재 로그인된 유저 ID 가져오기
      final userId = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';

      if (userId == null) {
        throw Exception('로그인 정보가 없습니다. DB에 저장할 수 없습니다.');
      }

      // ProfileModel의 필드명(json key)과 동일하게 맵핑하여 전송
      await supabase.from('profiles').upsert({
        'id': userId,
        'nickname': nickname,
        'profile_image_url': profileImageUrl,
        'pin_code': pinCode,
        'is_lock_enabled': lockEnabled,
        'is_noti_enabled': notificationEnabled,
        // period를 DB의 noti_time 타입(String)에 맞게 변환 (예: "3" 또는 "3 days")
        // 모델에서 String? notiTime 으로 정의되어 있으므로 적절히 변환해줍니다.
        'noti_time': period.days.toString(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Supabase 프로필 저장 에러: $e');
      rethrow; // UI 단에서 에러 스낵바를 띄우기 위해 에러를 던짐
    }
  }

  /// 프로필 정보 업데이트 (DB & 로컬)
  static Future<void> updateProfile({
    required String nickname,
    String? profileImageUrl,
  }) async {
    final supabase = Supabase.instance.client;
    //final userId = supabase.auth.currentUser?.id;
    final userId = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';

    if (userId == null) throw Exception('로그인 정보가 없습니다.');

    // 1. Supabase DB 업데이트
    await supabase.from('profiles').update({
      'nickname': nickname,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
    }).eq('id', userId);

    // 2. 로컬 저장소(SharedPrefs) 동기화
    await setNickname(nickname);
    if (profileImageUrl != null) {
      await setProfileImageUrl(profileImageUrl);
    }
  }
}
