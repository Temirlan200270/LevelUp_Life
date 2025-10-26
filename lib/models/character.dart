// lib/models/character.dart
import 'dart:math';
import 'package:json_annotation/json_annotation.dart';
import 'package:levelup_life/models/syncable.dart';

part 'character.g.dart';

@JsonSerializable()
class Character with Syncable {
  String name;
  int level;
  int experience;
  int strength;
  int intelligence;
  int charisma;
  int stamina;
  int skillPoints;
  
  Character({
    this.name = 'Герой',
    this.level = 1,
    this.experience = 0,
    this.strength = 5,
    this.intelligence = 5,
    this.charisma = 5,
    this.stamina = 5,
    this.skillPoints = 0,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get experienceToNextLevel => level * 100;

  void gainExperience(int amount) {
    experience += amount;
    while (experience >= experienceToNextLevel) {
      _levelUp();
    }
  }

  void _levelUp() {
    experience -= experienceToNextLevel;
    level++;
    skillPoints++;
    strength += Random().nextInt(2) + 1;
    intelligence += Random().nextInt(2) + 1;
    charisma += Random().nextInt(2) + 1;
    stamina += Random().nextInt(2) + 1;
  }

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}