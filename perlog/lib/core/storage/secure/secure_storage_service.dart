import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const _storage = FlutterSecureStorage();

  // 기본 CRUD
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw Exception('SecureStorage write failed: $e');
    }
  }

  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw Exception('SecureStorage read failed: $e');
    }
  }

  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw Exception('SecureStorage delete failed: $e');
    }
  }

  static Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw Exception('SecureStorage clear failed: $e');
    }
  }

  // 로그인
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static Future<void> setAccessToken(String token) async {
    await write(_accessTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    return await read(_accessTokenKey);
  }

  static Future<void> deleteAccessToken() async {
    await delete(_accessTokenKey);
  }

  static Future<void> setRefreshToken(String token) async {
    await write(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    return await read(_refreshTokenKey);
  }

  static Future<void> deleteRefreshToken() async {
    await delete(_refreshTokenKey);
  }

  static Future<void> clearAuth() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }

  // PIN 설정
  static const _pinKey = 'pin_hash';

  static Future<void> setPinHash(String hash) async {
    await write(_pinKey, hash);
  }

  static Future<String?> getPinHash() async {
    return await read(_pinKey);
  }

  static Future<void> deletePin() async {
    await delete(_pinKey);
  }

  static Future<bool> hasPin() async {
    final pin = await getPinHash();
    return pin != null;
  }
}