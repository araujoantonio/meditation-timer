import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/meditation_config.dart';
import '../services/bell_service.dart';
import 'pause_screen.dart';

class MeditationScreen extends StatefulWidget {
  final MeditationConfig config;

  const MeditationScreen({super.key, required this.config});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final BellService _bellService = BellService();
  Duration _elapsed = Duration.zero;
  late Duration _nextBellAt;
  Timer? _timer;
  int _bellCount = 0;

  @override
  void initState() {
    super.initState();
    _nextBellAt = widget.config.warmup;
    WakelockPlus.enable();
    _bellService.init().then((_) => _startTimer());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
      if (_elapsed >= _nextBellAt) {
        _bellService.playBell();
        _bellCount++;
        _nextBellAt += widget.config.interval;
      }
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  void _resume() {
    _startTimer();
  }

  void _finish() {
    _timer?.cancel();
    _bellService.dispose();
    WakelockPlus.disable();
    Navigator.of(context).pop();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _onPause() async {
    _pause();
    final result = await Navigator.of(context).push<String>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PauseScreen(
          elapsed: _elapsed,
          bellCount: _bellCount,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
    if (!mounted) return;
    if (result == 'continue') {
      _resume();
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bellService.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Breathing circle indicator
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0x33A8B5E2),
                      width: 1,
                    ),
                    color: const Color(0x0DA8B5E2),
                  ),
                  child: Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x22A8B5E2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _formatDuration(_elapsed),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 2,
                            color: Color(0xFFE0E0F0),
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _bellCount == 0
                      ? 'warming up'
                      : '$_bellCount bell${_bellCount == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                    color: Color(0x77A8B5E2),
                  ),
                ),
                const SizedBox(height: 56),
                GestureDetector(
                  onTap: _onPause,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF232342),
                      border: Border.all(
                        color: const Color(0x33A8B5E2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.pause_rounded,
                      size: 28,
                      color: Color(0xFFA8B5E2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
