// lib/repositories/skill_repository.dart
import 'package:levelup_life/models/skill.dart';
import 'package:levelup_life/services/data_service.dart';
import 'package:levelup_life/utils/debounce_controller.dart';

class SkillRepository {
  final DebounceController _debounceController = DebounceController();
  
  SkillRepository();

  Future<List<Skill>> getSkills() => DataService.loadSkills();

  Future<void> saveSkills(List<Skill> skills) async {
    _debounceController.run(const Duration(seconds: 2), () {
      DataService.saveSkills(skills);
    });
  }

  Future<void> resetSkills() => DataService.clearSkills();

  void dispose() => _debounceController.dispose();
}