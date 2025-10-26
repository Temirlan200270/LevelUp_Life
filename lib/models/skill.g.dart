// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  level: (json['level'] as num?)?.toInt() ?? 0,
  maxLevel: (json['maxLevel'] as num?)?.toInt() ?? 5,
);

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'level': instance.level,
  'maxLevel': instance.maxLevel,
};
