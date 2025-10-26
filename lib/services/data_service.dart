// lib/services/data_service.dart
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:levelup_life/models/character.dart';
import 'package:levelup_life/models/quest.dart';
import 'package:levelup_life/models/skill.dart';
import 'package:uuid/uuid.dart';

class DataService {
  static const _characterKey = 'character_data_v3';
  static const _questsKey = 'quests_data_v3';
  static const _skillsKey = 'skills_data_v3';
  static const _uuid = Uuid();
  static final _lock = Lock();
  static SharedPreferences? _prefs;
  static final _logger = Logger();

  static Future<void> init() async {
    try {
      _logger.i('Initializing DataService...');
      _prefs ??= await SharedPreferences.getInstance();
      _logger.i('DataService initialized successfully');
    } catch (e) {
      _logger.e('Error initializing DataService: $e');
      rethrow;
    }
  }

  static Future<bool> saveCharacter(Character data) => _saveData(_characterKey, data.toJson());
  static Future<bool> saveQuests(List<Quest> data) => _saveData(_questsKey, data.map((e) => e.toJson()).toList());
  static Future<bool> saveSkills(List<Skill> data) => _saveData(_skillsKey, data.map((e) => e.toJson()).toList());
  
  static Future<bool> _saveData(String key, dynamic data) async {
    final sw = Stopwatch()..start();
    return _lock.synchronized(() async {
      try {
        await _prefs!.setString(key, jsonEncode(data));
        _logger.i('Save to $key took ${sw.elapsedMilliseconds}ms');
        return true;
      } catch (e) {
        _logger.e('Ошибка при сохранении данных по ключу $key', error: e);
        return false;
      } finally {
        sw.stop();
      }
    });
  }
  
  static Future<Character> loadCharacter() async => _loadAndParse(_characterKey, (j) => Character.fromJson(j), () => Character());
  static Future<List<Quest>> loadQuests() async => _loadAndParse(_questsKey, (j) => (j as List).map((i) => Quest.fromJson(i)).toList(), () => []);
  static Future<List<Skill>> loadSkills() async => _loadAndParse(_skillsKey, (j) => (j as List).map((i) => Skill.fromJson(i)).toList(), () => _createDefaultSkills());

  static Future<T> _loadAndParse<T>(String key, T Function(dynamic) fromJson, T Function() defaultVal) async {
    final sw = Stopwatch()..start();
    try {
      final jsonString = await _loadStringWithBackup(key);
      if (jsonString != null) {
        final data = fromJson(jsonDecode(jsonString));
        _logger.i('Load from $key took ${sw.elapsedMilliseconds}ms');
        return data;
      }
    } catch (e) {
      _logger.w('Ошибка парсинга $key, пытаемся восстановить из бэкапа', error: e);
      try {
        final backupJson = _prefs!.getString('${key}_backup');
        if (backupJson != null) {
          final data = fromJson(jsonDecode(backupJson));
          _logger.i('Успешное восстановление из бэкапа для $key');
          await _saveData(key, jsonDecode(backupJson));
          return data;
        }
      } catch (backupError) {
        _logger.e('Бэкап для $key также поврежден', error: backupError);
      }
    }
    _logger.w('Возвращаем дефолтные значения для $key');
    await _clearKey(key);
    return defaultVal();
  }

  static Future<String?> _loadStringWithBackup(String key) async {
    final json = _prefs!.getString(key);
    if (json != null) await _prefs!.setString('${key}_backup', json);
    return json;
  }
  
  static Future<void> clearCharacter() => _clearKey(_characterKey);
  static Future<void> clearQuests() => _clearKey(_questsKey);
  static Future<void> clearSkills() => _clearKey(_skillsKey);
  
  static Future<void> _clearKey(String key) async {
    await _prefs!.remove(key);
    await _prefs!.remove('${key}_backup');
  }
  
  static List<Skill> _createDefaultSkills() => [
    Skill(id: _uuid.v4(), name: 'Ранний подъем', description: 'Увеличивает получаемую выносливость.'),
    Skill(id: _uuid.v4(), name: 'Быстрое чтение', description: 'Увеличивает получаемый интеллект.'),
    Skill(id: _uuid.v4(), name: 'Социальная уверенность', description: 'Увеличивает получаемую харизму.'),
    Skill(id: _uuid.v4(), name: 'Физическая сила', description: 'Увеличивает получаемую силу.'),
  ];
}