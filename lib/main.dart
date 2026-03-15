import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MeditationTimerApp());
}

class MeditationTimerApp extends StatelessWidget {
  const MeditationTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: '.SF Pro Display',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFA8B5E2),
          onPrimary: Color(0xFF1A1A2E),
          surface: Color(0xFF1A1A2E),
          onSurface: Color(0xFFE0E0F0),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: const BorderSide(color: Color(0x33A8B5E2)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
