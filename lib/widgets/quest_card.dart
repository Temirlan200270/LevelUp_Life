// lib/widgets/quest_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:levelup_life/models/quest.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback onCompleted;

  const QuestCard({super.key, required this.quest, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(quest.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onCompleted(),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Выполнить',
            borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
        ],
      ),
      child: Card(
        color: quest.isCompleted ? const Color(0xFF2E7D32).withOpacity(0.3) : Theme.of(context).cardTheme.color,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          leading: Icon(
            quest.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: quest.isCompleted ? Colors.green : Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            quest.title,
            style: TextStyle(
              decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
              color: quest.isCompleted ? Colors.grey[500] : Colors.white,
            ),
          ),
          trailing: Text('+${quest.xpReward} XP', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}