// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) =>
    Character(
        name: json['name'] as String? ?? 'Герой',
        level: (json['level'] as num?)?.toInt() ?? 1,
        experience: (json['experience'] as num?)?.toInt() ?? 0,
        strength: (json['strength'] as num?)?.toInt() ?? 5,
        intelligence: (json['intelligence'] as num?)?.toInt() ?? 5,
        charisma: (json['charisma'] as num?)?.toInt() ?? 5,
        stamina: (json['stamina'] as num?)?.toInt() ?? 5,
        skillPoints: (json['skillPoints'] as num?)?.toInt() ?? 0,
      )
      ..lastSync = json['lastSync'] == null
          ? null
          : DateTime.parse(json['lastSync'] as String);

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
  'lastSync': instance.lastSync?.toIso8601String(),
  'name': instance.name,
  'level': instance.level,
  'experience': instance.experience,
  'strength': instance.strength,
  'intelligence': instance.intelligence,
  'charisma': instance.charisma,
  'stamina': instance.stamina,
  'skillPoints': instance.skillPoints,
};
