// lib/providers/character_notifier.dart
import 'package:flutter/material.dart';
import 'package:levelup_life/main.dart';
import 'package:levelup_life/models/character.dart';
import 'package:levelup_life/repositories/character_repository.dart';

class CharacterNotifier extends ChangeNotifier {
  final CharacterRepository _repository;
  Character? _character;
  Character? get character => _character;

  CharacterNotifier(this._repository);

  Future<void> loadData() async {
    _character = await _repository.getCharacter();
    logger.i('Character data loaded.');
    notifyListeners();
  }

  void addExperience(int amount) {
    if (_character == null) return;
    final levelBefore = _character!.level;
    _character!.gainExperience(amount);
    if (_character!.level > levelBefore) {
      logger.i('LEVEL UP! New level: ${_character!.level}');
    }
    _repository.saveCharacter(_character!);
    notifyListeners();
  }

  void spendSkillPoint() {
    if (_character != null && _character!.skillPoints > 0) {
      _character!.skillPoints--;
      _repository.saveCharacter(_character!);
      notifyListeners();
    }
  }

  Future<void> resetData() async {
    await _repository.resetCharacter();
    await loadData();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}