enum NotificationPeriod {
  oneDay,
  threeDays,
  oneWeek,
}

extension NotificationPeriodX on NotificationPeriod {
  /// UI 표시용
  String get label {
    switch (this) {
      case NotificationPeriod.oneDay:
        return '1일';
      case NotificationPeriod.threeDays:
        return '3일';
      case NotificationPeriod.oneWeek:
        return '일주일';
    }
  }

  /// 저장용 (enum → int)
  int get days {
    switch (this) {
      case NotificationPeriod.oneDay:
        return 1;
      case NotificationPeriod.threeDays:
        return 3;
      case NotificationPeriod.oneWeek:
        return 7;
    }
  }

  /// 복원용 (int → enum)
  static NotificationPeriod fromDays(int days) {
    switch (days) {
      case 1:
        return NotificationPeriod.oneDay;
      case 3:
        return NotificationPeriod.threeDays;
      case 7:
        return NotificationPeriod.oneWeek;
      default:
        return NotificationPeriod.threeDays;
    }
  }
}