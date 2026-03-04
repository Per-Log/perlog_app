enum CalendarValidationResult {
  valid,
  future,
  pastLimit,
}

class CalendarPolicy {
  static CalendarValidationResult validate(DateTime selectedDay) {
    final today = DateTime.now();
    final normalizedToday =
        DateTime(today.year, today.month, today.day);

    final normalizedSelected = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );

    final diff = normalizedSelected.difference(normalizedToday).inDays;

    if (diff > 0) {
      return CalendarValidationResult.future;
    }

    if (diff < -3) {
      return CalendarValidationResult.pastLimit;
    }

    return CalendarValidationResult.valid;
  }
}