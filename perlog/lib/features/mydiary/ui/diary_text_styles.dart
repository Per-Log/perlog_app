import 'package:flutter/material.dart';
import 'package:perlog/features/mydiary/ui/diary_fonts.dart';

class DiaryTextStyles {
  DiaryTextStyles._();

  /// 기본 본문 스타일
  static TextStyle content({
    required String fontFamily,
    double fontSize = 18,
    Color color = Colors.black,
  }) {
    final scale = DiaryFontConfig.fontSizeScale[fontFamily] ?? 1.0;

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize * scale,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: color,
    );
  }

  /// 제목 스타일
  static TextStyle title({
    required String fontFamily,
    Color color = Colors.black,
  }) {
    final scale = DiaryFontConfig.fontSizeScale[fontFamily] ?? 1.0;

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 22 * scale,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: color,
    );
  }

  /// 날짜 스타일
  static TextStyle date({
    required String fontFamily,
    Color color = Colors.grey,
  }) {
    final scale = DiaryFontConfig.fontSizeScale[fontFamily] ?? 1.0;

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14 * scale,
      fontWeight: FontWeight.w400,
      height: 1.3,
      color: color,
    );
  }

  /// 강조 텍스트 (bold 느낌)
  static TextStyle highlight({
    required String fontFamily,
    Color color = Colors.black,
  }) {
    return content(
      fontFamily: fontFamily,
      color: color,
    ).copyWith(
      fontWeight: FontWeight.w600,
    );
  }

  /// hint / placeholder
  static TextStyle hint({
    required String fontFamily,
  }) {
    return content(
      fontFamily: fontFamily,
      color: Colors.grey,
    );
  }

  /// 미리보기용 (폰트 선택 UI에서 사용)
  static TextStyle preview({
    required String fontFamily,
  }) {
    final scale = DiaryFontConfig.fontSizeScale[fontFamily] ?? 1.0;

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16 * scale,
      height: 1.4,
      color: Colors.black,
    );
  }
}