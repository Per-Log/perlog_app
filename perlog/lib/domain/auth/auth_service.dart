import 'package:perlog/core/storage/secure/secure_storage_service.dart';

class AuthService {
  AuthService._();

  // 로그인 상태 관리
  static Future<bool> isLoggedIn() async {
    final token = await SecureStorageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // 토큰 저장
  static Future<void> login({
    required String accessToken,
    String? refreshToken,
  }) async {
    await SecureStorageService.setAccessToken(accessToken);

    if (refreshToken != null) {
      await SecureStorageService.setRefreshToken(refreshToken);
    }
  }

  // 액세스 토큰 조회
  static Future<String?> getAccessToken() async {
    return await SecureStorageService.getAccessToken();
  }

  // 로그아웃
  static Future<void> logout() async {
    await SecureStorageService.clearAuth();
  }

  // 탈퇴
  static Future<void> withdraw() async {
    // TODO: 서버 탈퇴 API 연동 필요
    await SecureStorageService.clearAuth();
    await SecureStorageService.deletePin();
  }
}