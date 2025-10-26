// lib/models/skill.dart
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

@JsonSerializable()
class Skill {
  final String id;
  final String name;
  final String description;
  int level;
  final int maxLevel;

  @JsonKey(includeFromJson: false, includeToJson: false)
  IconData get icon => _iconMap[name] ?? Icons.star;
  
  Skill({
    required this.id,
    required this.name,
    required this.description,
    this.level = 0,
    this.maxLevel = 5,
  });

  static final Map<String, IconData> _iconMap = {
    'Ранний подъем': Icons.wb_sunny_rounded,
    'Быстрое чтение': Icons.menu_book_rounded,
    'Социальная уверенность': Icons.people_rounded,
    'Физическая сила': Icons.fitness_center_rounded,
  };

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}