enum NotificationPeriod {
  oneDay,
  threeDays,
  oneWeek,
}

extension NotificationPeriodX on NotificationPeriod {
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
}
