import 'package:flutter/material.dart';

class PauseScreen extends StatelessWidget {
  final Duration elapsed;
  final int bellCount;

  const PauseScreen({
    super.key,
    required this.elapsed,
    required this.bellCount,
  });

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.pause_circle_outline_rounded,
                    size: 48,
                    color: Color(0x77A8B5E2),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Paused',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4,
                      color: Color(0xFFE0E0F0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_formatDuration(elapsed)}  ·  $bellCount bell${bellCount == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0x77A8B5E2),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop('continue'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFA8B5E2),
                        foregroundColor: const Color(0xFF1A1A2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop('finish'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0x99E0E0F0),
                        side: const BorderSide(color: Color(0x22A8B5E2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stop_rounded, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Finish',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
