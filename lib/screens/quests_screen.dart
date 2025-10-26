// lib/screens/quests_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:levelup_life/models/achievement.dart';
import 'package:levelup_life/models/quest.dart';
import 'package:levelup_life/providers/character_notifier.dart';
import 'package:levelup_life/providers/quest_notifier.dart';
import 'package:levelup_life/widgets/quest_card.dart';
import 'package:provider/provider.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});
  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  QuestDifficulty _selectedDifficulty = QuestDifficulty.medium;

  void _addQuest(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<QuestNotifier>().addQuest(_titleController.text, _selectedDifficulty);
      _titleController.clear();
      Navigator.of(context).pop();
    }
  }

  void _showAddQuestDialog() {
    _selectedDifficulty = QuestDifficulty.medium;
    showDialog(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Новый квест'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Название квеста'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Название не может быть пустым' : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<QuestDifficulty>(
                      value: _selectedDifficulty,
                      items: QuestDifficulty.values.map((d) => DropdownMenuItem(value: d, child: Text(d.toString().split('.').last.toUpperCase()))).toList(),
                      onChanged: (val) => setDialogState(() => _selectedDifficulty = val!),
                      decoration: const InputDecoration(labelText: 'Сложность'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Отмена')),
                ElevatedButton(onPressed: () => _addQuest(dialogContext), child: const Text('Добавить')),
              ],
            );
          }
        ),
      );
  }

  void _onQuestCompleted(Quest quest) {
    final characterNotifier = context.read<CharacterNotifier>();
    final questNotifier = context.read<QuestNotifier>();
    final levelBefore = characterNotifier.character!.level;
    
    questNotifier.completeQuest(quest);
    
    final levelAfter = characterNotifier.character!.level;
    
    _showToast('+${quest.xpReward} XP');

    if (levelAfter > levelBefore) {
      _showLevelUpDialog(levelAfter);
    }
    
    final newAchievement = questNotifier.lastUnlockedAchievement;
    if (newAchievement != null) {
      _showAchievementDialog(newAchievement);
      questNotifier.clearLastAchievement();
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.black.withOpacity(0.7),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    ));
  }
  
  void _showAchievementDialog(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2033),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(achievement.icon, color: Colors.amber, size: 50),
            const SizedBox(height: 16),
            Text('Достижение открыто!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text(achievement.name, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ],
        ),
        actions: [Center(child: ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Круто!')))],
      ),
    );
  }

  void _showLevelUpDialog(int newLevel) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A2033),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animation/level_up.json', width: 150, height: 150, fit: BoxFit.fill),
              Text('УРОВЕНЬ ПОВЫШЕН!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              Text('Вы достигли ${newLevel} уровня!', style: const TextStyle(fontSize: 18)),
              const Text('+1 очко навыков', style: TextStyle(fontSize: 16, color: Colors.yellow)),
            ],
          ),
          actions: [Center(child: ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отлично!')))],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final quests = context.watch<QuestNotifier>().quests;
    quests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final activeQuests = quests.where((q) => !q.isCompleted).toList();
    final completedQuests = quests.where((q) => q.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Квесты')),
      body: quests.isEmpty
          ? const Center(child: Text('Нет активных квестов.', style: TextStyle(color: Colors.grey)))
          : ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: [
                if (activeQuests.isNotEmpty) ...[
                  Padding(padding: const EdgeInsets.all(16.0), child: Text('Активные', style: Theme.of(context).textTheme.titleLarge)),
                  ...activeQuests.map((quest) => QuestCard(quest: quest, onCompleted: () => _onQuestCompleted(quest))),
                ],
                if (completedQuests.isNotEmpty) ...[
                  Padding(padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0), child: Text('Выполненные', style: Theme.of(context).textTheme.titleLarge)),
                  ...completedQuests.map((quest) => QuestCard(quest: quest, onCompleted: () {})),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddQuestDialog, child: const Icon(Icons.add)),
    );
  }
}