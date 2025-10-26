// lib/widgets/stat_bar.dart
import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final int maxValue;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    this.color = Colors.cyan,
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value.toDouble() / maxValue.toDouble(),
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}