// lib/providers/skill_notifier.dart
import 'package:flutter/material.dart';
import 'package:levelup_life/main.dart';
import 'package:levelup_life/models/skill.dart';
import 'package:levelup_life/providers/character_notifier.dart';
import 'package:levelup_life/repositories/skill_repository.dart';

class SkillNotifier extends ChangeNotifier {
  final CharacterNotifier? _characterNotifier;
  final SkillRepository _repository;
  List<Skill> _skills = [];

  SkillNotifier(this._characterNotifier, this._repository);

  List<Skill> get skills => _skills;

  Future<void> loadData() async {
    _skills = await _repository.getSkills();
    logger.i('Skills data loaded.');
    notifyListeners();
  }

  void levelUpSkill(Skill skill) {
    if (_characterNotifier?.character == null) return;
    if (_characterNotifier!.character!.skillPoints > 0 && skill.level < skill.maxLevel) {
      skill.level++;
      _characterNotifier!.spendSkillPoint();
      _repository.saveSkills(_skills);
      notifyListeners();
    }
  }

  Future<void> resetData() async {
    await _repository.resetSkills();
    await loadData();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}