import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  PrefService._();

  static Future<SharedPreferences> _prefs() async =>
      await SharedPreferences.getInstance();

  /// String
  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await _prefs();
    return prefs.getString(key);
  }

  static Future<String> getStringOrDefault(
      String key, String defaultValue) async {
    final prefs = await _prefs();
    return prefs.getString(key) ?? defaultValue;
  }

  /// Bool
  static Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await _prefs();
    return prefs.getBool(key);
  }

  static Future<bool> getBoolOrDefault(
      String key, bool defaultValue) async {
    final prefs = await _prefs();
    return prefs.getBool(key) ?? defaultValue;
  }

  /// Int
  static Future<void> setInt(String key, int value) async {
    final prefs = await _prefs();
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await _prefs();
    return prefs.getInt(key);
  }

  /// Remove
  static Future<void> remove(String key) async {
    final prefs = await _prefs();
    await prefs.remove(key);
  }
}