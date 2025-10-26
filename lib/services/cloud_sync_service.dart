// lib/services/cloud_sync_service.dart
import 'package:levelup_life/models/character.dart';

class CloudSyncService {
  Future<void> syncCharacter(Character character) async {
    // В будущем здесь будет логика отправки данных в Firestore
    await Future.delayed(const Duration(seconds: 1));
  }
}