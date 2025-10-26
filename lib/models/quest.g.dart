// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quest _$QuestFromJson(Map<String, dynamic> json) => Quest(
  id: json['id'] as String,
  title: json['title'] as String,
  isCompleted: json['isCompleted'] as bool? ?? false,
  type:
      $enumDecodeNullable(_$QuestTypeEnumMap, json['type']) ?? QuestType.daily,
  difficulty:
      $enumDecodeNullable(_$QuestDifficultyEnumMap, json['difficulty']) ??
      QuestDifficulty.medium,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$QuestToJson(Quest instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'isCompleted': instance.isCompleted,
  'type': _$QuestTypeEnumMap[instance.type]!,
  'difficulty': _$QuestDifficultyEnumMap[instance.difficulty]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$QuestTypeEnumMap = {QuestType.daily: 'daily', QuestType.main: 'main'};

const _$QuestDifficultyEnumMap = {
  QuestDifficulty.easy: 'easy',
  QuestDifficulty.medium: 'medium',
  QuestDifficulty.hard: 'hard',
};
