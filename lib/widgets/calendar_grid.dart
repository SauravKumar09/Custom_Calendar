import 'package:flutter/material.dart';
import '../models/calendar_controller.dart' as model;

class CalendarGrid extends StatelessWidget {
  final model.CalendarController controller;
  final ValueChanged<DateTime> onDateSelected;
  final Color dateTextColor;
  final Color dayLetterColor;
  final bool Function(DateTime date) isDateInRange;
  final DateTime? startDate;
  final DateTime? endDate;

  const CalendarGrid({
    super.key,
    required this.controller,
    required this.onDateSelected,
    required this.dateTextColor,
    required this.dayLetterColor,
    required this.isDateInRange,
    required this.startDate,
    required this.endDate,
  });

  List<DateTime> _generateDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysBefore = firstDay.weekday % 7;
    final firstToDisplay = firstDay.subtract(Duration(days: daysBefore));

    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysAfter = 6 - (lastDay.weekday % 7);
    final lastToDisplay = lastDay.add(Duration(days: daysAfter));

    final days = <DateTime>[];
    for (
      DateTime day = firstToDisplay;
      !day.isAfter(lastToDisplay);
      day = day.add(const Duration(days: 1))
    ) {
      days.add(day);
    }
    return days;
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _generateDaysInMonth(controller.currentMonth);

    // Select background color depending on theme
    final rangeBgColor =
        Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF342B5B) // Dark mode
            : const Color(0xFFE8E3FE); // Light mode

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: daysInMonth.length,
      itemBuilder: (context, index) {
        final date = daysInMonth[index];

        final isStart = startDate != null && _isSameDate(date, startDate!);
        final isEnd = endDate != null && _isSameDate(date, endDate!);
        final isInSelectedRange = isDateInRange(date) && !isStart && !isEnd;

        final isCurrentMonth = date.month == controller.currentMonth.month;

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Stack(
            children: [
              // Background highlight for range (rectangle full cell)
              if (isInSelectedRange) Container(color: rangeBgColor),

              // Start/end date circle highlight
              Center(
                child: Container(
                  decoration:
                      (isStart || isEnd)
                          ? const BoxDecoration(
                            color: Color(0xFF7D60FF),
                            shape: BoxShape.circle,
                          )
                          : null,
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color:
                          isCurrentMonth
                              ? (isStart || isEnd
                                  ? Colors.white
                                  : dateTextColor)
                              : Colors.transparent,
                      fontWeight:
                          (isStart || isEnd)
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
