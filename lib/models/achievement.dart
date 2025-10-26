  // lib/models/achievement.dart
import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  Achievement({required this.id, required this.name, required this.description, required this.icon});
}