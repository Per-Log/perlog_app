import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String pretendard = 'Pretendard';
  static const String pretendardVariable = 'PretendardVariable';
  static const String paperlogy = 'Paperlogy';

  /// Paperlogy 6 SemiBold | 50pt | LetterSpacing -5%
  static const TextStyle headline50 = TextStyle(
    fontFamily: paperlogy,
    fontSize: 50,
    fontWeight: FontWeight.w600,
    letterSpacing: -2.5, // 50 * -0.05
    height: 1.2,
  );

  /// Pretendard Variable Medium | 20pt
  static const TextStyle body20Medium = TextStyle(
    fontFamily: pretendardVariable,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// Pretendard Variable SemiBold | 18pt
  static const TextStyle body18SemiBold = TextStyle(
    fontFamily: pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Pretendard Variable Regular | 18pt
  static const TextStyle body18 = TextStyle(
    fontFamily: pretendardVariable,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Pretendard Variable Regular | 16pt
  static const TextStyle body16 = TextStyle(
    fontFamily: pretendardVariable,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Pretendard Variable Regular | 14pt
  static const TextStyle body14 = TextStyle(
    fontFamily: pretendardVariable,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// Pretendard Variable Regular | 11pt
  static const TextStyle body11 = TextStyle(
    fontFamily: pretendardVariable,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );
}
