class CalendarController {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  void changeMonth(DateTime newFocused) {
    focusedDay = newFocused;
  }

  void selectDay(DateTime day) {
    selectedDay = day;
    focusedDay = day;
  }
}