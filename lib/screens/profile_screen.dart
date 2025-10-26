// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:levelup_life/models/character.dart';
import 'package:levelup_life/providers/character_notifier.dart';
import 'package:levelup_life/providers/quest_notifier.dart';
import 'package:levelup_life/providers/skill_notifier.dart';
import 'package:levelup_life/screens/stats_screen.dart';
import 'package:levelup_life/widgets/stat_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Начать новую жизнь?'),
        content: const Text('Весь ваш прогресс будет сброшен. Это действие необратимо.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              if (await Vibration.hasVibrator() ?? false) Vibration.vibrate();
              context.read<CharacterNotifier>().resetData();
              context.read<QuestNotifier>().resetData();
              context.read<SkillNotifier>().resetData();
            },
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CharacterNotifier>().character;
    if (character == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Статистика',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StatsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_backup_restore_rounded),
            tooltip: 'Сбросить прогресс',
            onPressed: () => _showResetConfirmationDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(context, character),
            const SizedBox(height: 30),
            _buildStats(context, character),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, Character character) {
    double percent = character.experience.toDouble() / character.experienceToNextLevel.toDouble();
    
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: percent > 1 ? 1 : percent),
      duration: const Duration(milliseconds: 700),
      builder: (context, value, child) {
        return CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 10.0,
          percent: value,
          center: CircleAvatar(radius: 65, backgroundColor: Colors.deepPurple, child: Text('Ур.\n${character.level}', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall)),
          progressColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.grey.withOpacity(0.2),
          circularStrokeCap: CircularStrokeCap.round,
          footer: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                Text('Опыт: ${character.experience} / ${character.experienceToNextLevel}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Очки навыков: ${character.skillPoints}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.yellow)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStats(BuildContext context, Character character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ХАРАКТЕРИСТИКИ', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
        const Divider(thickness: 1),
        const SizedBox(height: 10),
        StatBar(label: 'Сила', value: character.strength, color: Colors.redAccent),
        StatBar(label: 'Интеллект', value: character.intelligence, color: Colors.blueAccent),
        StatBar(label: 'Харизма', value: character.charisma, color: Colors.purpleAccent),
        StatBar(label: 'Выносливость', value: character.stamina, color: Colors.greenAccent),
      ],
    );
  }
}