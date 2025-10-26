// lib/repositories/quest_repository.dart
import 'package:levelup_life/models/quest.dart';
import 'package:levelup_life/services/data_service.dart';
import 'package:levelup_life/utils/debounce_controller.dart';

class QuestRepository {
  final DebounceController _debounceController = DebounceController();
  
  QuestRepository();
  
  Future<List<Quest>> getQuests() => DataService.loadQuests();

  Future<void> saveQuests(List<Quest> quests) async {
    _debounceController.run(const Duration(seconds: 2), () {
      DataService.saveQuests(quests);
    });
  }

  Future<void> resetQuests() => DataService.clearQuests();

  void dispose() => _debounceController.dispose();
}