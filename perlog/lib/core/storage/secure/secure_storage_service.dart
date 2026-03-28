import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const _storage = FlutterSecureStorage();

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }

  static const _accessTokenKey = 'access_token';

  static Future<void> setAccessToken(String token) async {
    await write(_accessTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    return await read(_accessTokenKey);
  }

  static Future<void> deleteAccessToken() async {
    await delete(_accessTokenKey);
  }

  static const _refreshTokenKey = 'refresh_token';

  static Future<void> setRefreshToken(String token) async {
    await write(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    return await read(_refreshTokenKey);
  }

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
}