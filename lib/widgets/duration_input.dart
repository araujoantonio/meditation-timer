import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Duration? parseDuration(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;

  final parts = trimmed.split(':');
  if (parts.length == 1) {
    final minutes = int.tryParse(parts[0]);
    if (minutes == null || minutes < 0) return null;
    return Duration(minutes: minutes);
  } else if (parts.length == 2) {
    final minutes = int.tryParse(parts[0]);
    final seconds = int.tryParse(parts[1]);
    if (minutes == null || seconds == null) return null;
    if (minutes < 0 || seconds < 0 || seconds > 59) return null;
    return Duration(minutes: minutes, seconds: seconds);
  }
  return null;
}

class DurationInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const DurationInput({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: Color(0x99A8B5E2),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF232342),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x1AFFFFFF)),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
              color: Color(0xFFE0E0F0),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d:]')),
              LengthLimitingTextInputFormatter(5),
            ],
            decoration: const InputDecoration(
              hintText: '0:00',
              hintStyle: TextStyle(
                color: Color(0x44E0E0F0),
                fontSize: 28,
                fontWeight: FontWeight.w300,
                letterSpacing: 4,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}
