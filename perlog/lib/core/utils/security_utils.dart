import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityUtils {
  SecurityUtils._();

  static String hashPin(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }
}