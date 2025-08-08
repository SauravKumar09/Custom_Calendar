import 'package:flutter/material.dart';
import 'models/calendar_controller.dart';
import 'widgets/custom_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Calendar',
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        // scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        // scaffoldBackgroundColor: Colors.black,
      ),
      home: CalendarScreen(
        toggleTheme: toggleTheme,
        isLightMode: themeMode == ThemeMode.light,
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isLightMode;

  const CalendarScreen({
    super.key,
    required this.toggleTheme,
    required this.isLightMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF444444), // Always dark gray background
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48), // Space to balance toggle button
                Text(
                  "Custom Calendar",
                  style: const TextStyle(
                    color: Colors.white, // Always white title
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.brightness_6,
                    color: isLightMode ? Colors.white : Colors.white,
                    // White in both modes
                  ),
                  onPressed: toggleTheme,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Calendar widget
            Expanded(
              child: CustomCalendar(
                controller: CalendarController(),
                lightMode: isLightMode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
