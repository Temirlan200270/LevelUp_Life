// lib/repositories/character_repository.dart
import 'package:levelup_life/models/character.dart';
import 'package:levelup_life/services/cloud_sync_service.dart';
import 'package:levelup_life/services/data_service.dart';
import 'package:levelup_life/utils/debounce_controller.dart';

class CharacterRepository {
  final CloudSyncService _cloudService;
  final DebounceController _debounceController = DebounceController();

  CharacterRepository({required CloudSyncService cloudService}) : _cloudService = cloudService;

  Future<Character> getCharacter() => DataService.loadCharacter();
  
  Future<void> saveCharacter(Character character) async {
    _debounceController.run(const Duration(seconds: 2), () {
      DataService.saveCharacter(character);
      _cloudService.syncCharacter(character);
    });
  }
  
  Future<void> resetCharacter() => DataService.clearCharacter();
  
  void dispose() => _debounceController.dispose();
}