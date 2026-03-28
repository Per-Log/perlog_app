import 'package:perlog/core/storage/pref/pref_keys.dart';
import 'package:perlog/core/storage/pref/pref_service.dart';
import 'package:perlog/core/storage/secure/secure_storage_service.dart';

class LockService {
  LockService._();

  // 잠금 활성화 여부
  static Future<bool> isLockEnabled() async {
    return await PrefService.getBoolOrDefault(
      PrefKeys.lockEnabled,
      false,
    );
  }

  static Future<void> setLockEnabled(bool enabled) async {
    await PrefService.setBool(PrefKeys.lockEnabled, enabled);
  }

  // PIN 관련
  static Future<bool> hasPin() async {
    return await SecureStorageService.hasPin();
  }

  static Future<void> setPin(String hash) async {
    await SecureStorageService.setPinHash(hash);
  }

  static Future<void> removePin() async {
    await SecureStorageService.deletePin();
  }

  static Future<String?> getPin() async {
    return await SecureStorageService.getPinHash();
  }

  // 실제 잠금 상태
  static Future<bool> shouldLock() async {
  final enabled = await isLockEnabled();
  final hasPinValue = await hasPin();

  return enabled && hasPinValue;
}
}