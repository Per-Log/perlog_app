import 'package:flutter/widgets.dart';

class AppSpacing {
  /// 기본 화면 좌우 패딩
  static const double horizontal = 24;

  /// 기본 화면 상하 패딩
  static const double vertical = 24;

  /// Screen padding
  static const EdgeInsets screen =
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// 가로 패딩만
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: horizontal);

  /// 하단 버튼 영역
  static const EdgeInsets bottomButton =
      EdgeInsets.fromLTRB(horizontal, 0, horizontal, 75);

  /// 카드 내부 패딩
  static const EdgeInsets card =
      EdgeInsets.all(16);
}
