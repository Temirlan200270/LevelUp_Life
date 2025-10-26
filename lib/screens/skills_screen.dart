// lib/screens/skills_screen.dart
import 'package:flutter/material.dart';
import 'package:levelup_life/models/skill.dart';
import 'package:levelup_life/providers/character_notifier.dart';
import 'package:levelup_life/providers/skill_notifier.dart';
import 'package:provider/provider.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  void _levelUpSkill(BuildContext context, Skill skill) {
    final characterNotifier = context.read<CharacterNotifier>();
    if (characterNotifier.character!.skillPoints <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Недостаточно очков навыков!')));
    } else {
      context.read<SkillNotifier>().levelUpSkill(skill);
    }
  }

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CharacterNotifier>().character;
    final skills = context.watch<SkillNotifier>().skills;
    if (character == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Дерево Навыков')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Доступно очков: ${character.skillPoints}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.yellow)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final skill = skills[index];
                final canLevelUp = character.skillPoints > 0 && skill.level < skill.maxLevel;
                return Card(
                  child: ListTile(
                    leading: Icon(skill.icon, color: Theme.of(context).colorScheme.primary, size: 30),
                    title: Text(skill.name),
                    subtitle: Text(skill.description, style: TextStyle(color: Colors.grey[400])),
                    trailing: ElevatedButton(
                      onPressed: canLevelUp ? () => _levelUpSkill(context, skill) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canLevelUp ? Theme.of(context).colorScheme.secondary : Colors.grey[800],
                      ),
                      child: Text('Ур. ${skill.level} / ${skill.maxLevel}'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}