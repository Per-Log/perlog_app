import 'package:flutter/widgets.dart';

class AppSpacing {
  /// 기본 좌우 패딩 
  static const double horizontal = 23;

  /// 기본 상하 패딩
  static const double vertical = 24;

  /// 카드 내부 패딩
  static const double cardPadding = 20;

  static EdgeInsets screen(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    final top = (h * 0.04).clamp(16.0, 32.0);
    final bottom = (h * 0.03).clamp(32.0, 64.0);

    return EdgeInsets.fromLTRB(
      horizontal,
      top,
      horizontal,
      bottom,
    );
  }

  static const EdgeInsets card = EdgeInsets.all(cardPadding);

  /// 반응형 ///
 
  /// 화면 세로 기준 기본 section 간격
  static double section(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return (h * 0.04).clamp(16.0, 32.0);
  }

  /// 작은 vertical gap (텍스트 사이 등)
  static double small(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return (h * 0.015).clamp(8.0, 16.0);
  }

  /// 중간 vertical gap (동일 섹션 내 다음 항목)
  static double medium(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return (h * 0.015).clamp(16.0, 24.0);
  }

  /// 큰 vertical gap (섹션 분리용)
  static double large(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return (h * 0.06).clamp(32.0, 56.0);
  }


  /// 하단 버튼 높이
  static double bottomButtonHeight(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return (h * 0.06).clamp(56.0, 64.0);
  }

  /// 하단 버튼 영역 padding (safe area 포함)
  static EdgeInsets bottomButtonPadding(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return EdgeInsets.fromLTRB(
      horizontal,
      0,
      horizontal,
      50 + bottomInset,
    );
  }
}
