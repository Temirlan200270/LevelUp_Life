// lib/services/achievement_service.dart
import 'package:flutter/material.dart';
import 'package:levelup_life/models/achievement.dart';
import 'package:levelup_life/models/character.dart';
import 'package:levelup_life/models/quest.dart';

class AchievementService {
  final List<Achievement> allAchievements = [
    Achievement(id: 'level_5', name: 'Пятый уровень', description: 'Достигнуть 5-го уровня.', icon: Icons.star),
    Achievement(id: 'quests_10', name: 'Квест-мастер', description: 'Выполнить 10 квестов.', icon: Icons.list_alt),
  ];
  
  Set<String> unlockedAchievementIds = {};

  Achievement? checkAchievements({Character? character, List<Quest>? quests}) {
    if (character != null) {
      if (character.level >= 5 && !unlockedAchievementIds.contains('level_5')) {
        unlockedAchievementIds.add('level_5');
        return allAchievements.firstWhere((a) => a.id == 'level_5');
      }
    }
    if (quests != null) {
      if (quests.where((q) => q.isCompleted).length >= 10 && !unlockedAchievementIds.contains('quests_10')) {
        unlockedAchievementIds.add('quests_10');
        return allAchievements.firstWhere((a) => a.id == 'quests_10');
      }
    }
    return null;
  }
}