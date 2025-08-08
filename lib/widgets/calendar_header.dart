import 'package:flutter/material.dart';
import '../models/calendar_controller.dart' as model;

class CalendarHeader extends StatelessWidget {
  final model.CalendarController controller;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final Color monthTextColor; // This replaces your 'color' param
  final Color dayLetterColor;
  final bool isPrevEnabled;
  final bool isNextEnabled;
  final bool showDaysOfWeek;

  const CalendarHeader({
    super.key,
    required this.controller,
    required this.onPrev,
    required this.onNext,
    required this.isPrevEnabled,
    required this.isNextEnabled,
    this.showDaysOfWeek = false,
    this.monthTextColor = const Color(0xFF7D60FF),
    this.dayLetterColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF7D60FF);
    final Color disabledColor = activeColor;

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                controller.monthName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: monthTextColor,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 24),
              onPressed: isPrevEnabled ? onPrev : null,
              padding: const EdgeInsets.only(right: 12),
              constraints: const BoxConstraints(),
              color: isPrevEnabled ? activeColor : disabledColor,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 24),
              onPressed: isNextEnabled ? onNext : null,
              padding: const EdgeInsets.only(right: 12),
              constraints: const BoxConstraints(),
              color: isNextEnabled ? activeColor : disabledColor,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Show days of week if enabled
        if (showDaysOfWeek)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                    .map(
                      (day) => Text(
                        day,
                        style: TextStyle(
                          color: dayLetterColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }
}
