// lib/models/quest.dart
import 'package:json_annotation/json_annotation.dart';

part 'quest.g.dart';

enum QuestType { daily, main }
enum QuestDifficulty { easy, medium, hard }

@JsonSerializable()
class Quest {
  final String id;
  String title;
  final int xpReward;
  bool isCompleted;
  final QuestType type;
  final QuestDifficulty difficulty;
  final DateTime createdAt;

  Quest({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.type = QuestType.daily,
    this.difficulty = QuestDifficulty.medium,
    required this.createdAt,
  }) : xpReward = _getXpForDifficulty(difficulty);
  
  static int _getXpForDifficulty(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy: return 10;
      case QuestDifficulty.medium: return 25;
      case QuestDifficulty.hard: return 50;
    }
  }
  
  void complete() {
    isCompleted = true;
  }

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
  Map<String, dynamic> toJson() => _$QuestToJson(this);
}