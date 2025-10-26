// lib/providers/quest_notifier.dart
import 'package:flutter/material.dart';
import 'package:levelup_life/main.dart';
import 'package:levelup_life/models/achievement.dart';
import 'package:levelup_life/models/quest.dart';
import 'package:levelup_life/providers/character_notifier.dart';
import 'package:levelup_life/repositories/quest_repository.dart';
import 'package:levelup_life/services/achievement_service.dart';
import 'package:uuid/uuid.dart';

class QuestNotifier extends ChangeNotifier {
  final CharacterNotifier? _characterNotifier;
  final QuestRepository _repository;
  final AchievementService _achievementService = AchievementService();
  List<Quest> _quests = [];
  final Uuid _uuid = const Uuid();
  Achievement? lastUnlockedAchievement;

  QuestNotifier(this._characterNotifier, this._repository);

  List<Quest> get quests => _quests;
  int get activeQuestCount => _quests.where((q) => !q.isCompleted).length;

  Future<void> loadData() async {
    _quests = await _repository.getQuests();
    logger.i('Quests data loaded.');
    notifyListeners();
  }
  
  void addQuest(String title, QuestDifficulty difficulty) {
    final newQuest = Quest(id: _uuid.v4(), title: title, difficulty: difficulty, createdAt: DateTime.now());
    _quests.insert(0, newQuest);
    _repository.saveQuests(_quests);
    notifyListeners();
  }

  void completeQuest(Quest quest) {
    if (_characterNotifier == null) return;
    quest.complete();
    _characterNotifier!.addExperience(quest.xpReward);
    _repository.saveQuests(_quests);
    _checkAchievements();
    notifyListeners();
  }

  void _checkAchievements() {
    final achievement = _achievementService.checkAchievements(
      character: _characterNotifier!.character,
      quests: _quests,
    );
    if (achievement != null) {
      lastUnlockedAchievement = achievement;
      logger.i('Achievement unlocked: ${achievement.name}');
    }
  }
  
  void clearLastAchievement() {
    lastUnlockedAchievement = null;
  }
  
  Future<void> resetData() async {
    await _repository.resetQuests();
    await loadData();
  }
  
  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}