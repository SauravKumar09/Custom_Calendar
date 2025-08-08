import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/calendar_controller.dart' as model;
import 'calendar_header.dart';
import 'calendar_grid.dart';

class CustomCalendar extends StatefulWidget {
  final model.CalendarController controller;
  final bool lightMode;

  const CustomCalendar({
    super.key,
    required this.controller,
    required this.lightMode,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late model.CalendarController controller;
  late bool useSwipeOnly;
  late Color _calendarBgColor;
  late Color _monthTextColor;
  late Color _dayLetterColor;
  late Color _dateTextColor;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;

    // Set default month to July
    controller.currentMonth = DateTime(DateTime.now().year, 7, 1);
  }

  void _applyColors() {
    if (widget.lightMode) {
      _calendarBgColor = Colors.white;
      _monthTextColor = const Color(0xFF7D60FF);
      _dayLetterColor = Colors.grey[600]!;
      _dateTextColor = Colors.black;
      useSwipeOnly = true;
    } else {
      _calendarBgColor = const Color(0xFF1A1A1A);
      _monthTextColor = const Color(0xFF7D60FF);
      _dayLetterColor = Colors.grey[400]!;
      _dateTextColor = Colors.white;
      useSwipeOnly = false;
    }
  }

  void onDateSelected(DateTime date) {
    setState(() {
      if (startDate == null || (startDate != null && endDate != null)) {
        startDate = date;
        endDate = null;
      } else if (startDate != null && endDate == null) {
        if (date.isBefore(startDate!)) {
          endDate = startDate;
          startDate = date;
        } else {
          endDate = date;
        }
      }
      controller.selectDate(date);
    });
  }

  bool isInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      return !date.isBefore(startDate!) && !date.isAfter(endDate!);
    }
    return false;
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;
    if (details.primaryVelocity! < 0) {
      // Next month
      setState(() => controller.goToNextMonth());
    } else if (details.primaryVelocity! > 0) {
      // Prev month only if allowed
      if (startDate == null ||
          (controller.currentMonth.isAfter(
                DateTime(startDate!.year, startDate!.month, 1),
              ) ||
              controller.currentMonth.month == startDate!.month &&
                  controller.currentMonth.year == startDate!.year)) {
        setState(() => controller.goToPreviousMonth());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _applyColors();

    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: widget.lightMode ? 2 : 4,
            color: _calendarBgColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(widget.lightMode ? 40 : 12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onHorizontalDragEnd: _handleSwipe,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!useSwipeOnly)
                      CalendarHeader(
                        controller: controller,
                        onPrev: () {
                          setState(() {
                            controller.goToPreviousMonth();
                          });
                        },
                        onNext: () {
                          setState(() {
                            controller.goToNextMonth();
                          });
                        },
                        monthTextColor: _monthTextColor,
                        dayLetterColor: _dayLetterColor,
                        showDaysOfWeek: true,
                        isPrevEnabled:
                            !controller.currentMonth.isBefore(
                              DateTime(2025, 7, 1),
                            ),
                        isNextEnabled: true,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.MMMM().format(controller.currentMonth),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: _monthTextColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                                      .map(
                                        (day) => Expanded(
                                          child: Center(
                                            child: Text(
                                              day,
                                              style: TextStyle(
                                                color: _dayLetterColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: CalendarGrid(
                        controller: controller,
                        onDateSelected: onDateSelected,
                        dateTextColor: _dateTextColor,
                        dayLetterColor: _dayLetterColor,
                        isDateInRange: isInRange,
                        startDate: startDate,
                        endDate: endDate,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
