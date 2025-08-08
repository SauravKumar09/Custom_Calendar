import 'package:intl/intl.dart';

class CalendarController {
  DateTime currentMonth = DateTime.now();
  DateTime? selectedDate;

  /// Returns the full month name, e.g., "August"
  String get monthName => DateFormat.MMMM().format(currentMonth);

  /// Returns the year, e.g., 2025
  int get year => currentMonth.year;

  void goToNextMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
  }

  void goToPreviousMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
  }

  void selectDate(DateTime date) {
    selectedDate = date;
  }

  bool isSelectedDate(DateTime date) {
    return selectedDate != null &&
        selectedDate!.year == date.year &&
        selectedDate!.month == date.month &&
        selectedDate!.day == date.day;
  }

  bool isToday(DateTime date) {
    final today = DateTime.now();
    return today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;
  }

  String getMonthYear() {
    return DateFormat('MMMM yyyy').format(currentMonth);
  }

  List<DateTime> getDaysInMonth() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday index = 0
    final days = <DateTime>[];

    for (int i = 0; i < firstWeekday; i++) {
      days.add(DateTime(0)); // padding days
    }

    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, i));
    }

    return days;
  }
}
