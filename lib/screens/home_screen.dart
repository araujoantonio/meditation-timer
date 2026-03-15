import 'package:flutter/material.dart';
import '../models/meditation_config.dart';
import '../widgets/duration_input.dart';
import 'meditation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _warmupController = TextEditingController(text: '5:00');
  final _intervalController = TextEditingController(text: '10:00');

  bool get _isValid {
    final warmup = parseDuration(_warmupController.text);
    final interval = parseDuration(_intervalController.text);
    return warmup != null &&
        interval != null &&
        warmup > Duration.zero &&
        interval > Duration.zero;
  }

  void _start() {
    final warmup = parseDuration(_warmupController.text)!;
    final interval = parseDuration(_intervalController.text)!;
    final config = MeditationConfig(warmup: warmup, interval: interval);

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MeditationScreen(config: config),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _warmupController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Icon(
                    Icons.self_improvement_rounded,
                    size: 48,
                    color: Color(0xFFA8B5E2),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Meditation',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4,
                      color: Color(0xFFE0E0F0),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Timer',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4,
                      color: Color(0xFFA8B5E2),
                    ),
                  ),
                  const SizedBox(height: 56),
                  DurationInput(
                    label: 'Warmup',
                    controller: _warmupController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  DurationInput(
                    label: 'Interval',
                    controller: _intervalController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _isValid ? _start : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFA8B5E2),
                        foregroundColor: const Color(0xFF1A1A2E),
                        disabledBackgroundColor: const Color(0xFF232342),
                        disabledForegroundColor: const Color(0x44E0E0F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Begin',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
