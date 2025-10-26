// lib/screens/stats_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:levelup_life/providers/character_notifier.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CharacterNotifier>().character;
    final dummyData = [
      FlSpot(0, (character?.level ?? 1) - 2 > 0 ? (character?.level ?? 1) - 2 : 1),
      FlSpot(1, (character?.level ?? 1) - 1 > 0 ? (character?.level ?? 1) - 1 : 1),
      FlSpot(2, character?.level.toDouble() ?? 1),
    ];
    
    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Прогресс уровня', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dummyData,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}