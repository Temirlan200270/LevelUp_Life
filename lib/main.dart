// lib/main.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:levelup_life/providers/character_notifier.dart';
import 'package:levelup_life/providers/quest_notifier.dart';
import 'package:levelup_life/providers/skill_notifier.dart';
import 'package:levelup_life/repositories/character_repository.dart';
import 'package:levelup_life/repositories/quest_repository.dart';
import 'package:levelup_life/repositories/skill_repository.dart';
import 'package:levelup_life/screens/home_screen.dart';
import 'package:levelup_life/services/cloud_sync_service.dart';
import 'package:levelup_life/services/data_service.dart';
import 'package:levelup_life/theme.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => CloudSyncService()),
        Provider(create: (context) => CharacterRepository(cloudService: context.read<CloudSyncService>())),
        Provider(create: (_) => QuestRepository()),
        Provider(create: (_) => SkillRepository()),
        
        ChangeNotifierProvider(create: (context) => CharacterNotifier(context.read<CharacterRepository>())),
        ChangeNotifierProxyProvider<CharacterNotifier, QuestNotifier>(
          create: (context) => QuestNotifier(null, context.read<QuestRepository>()),
          update: (_, characterNotifier, __) => QuestNotifier(characterNotifier, context.read<QuestRepository>()),
        ),
        ChangeNotifierProxyProvider<CharacterNotifier, SkillNotifier>(
          create: (context) => SkillNotifier(null, context.read<SkillRepository>()),
          update: (_, characterNotifier, __) => SkillNotifier(characterNotifier, context.read<SkillRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Level Up Life',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const InitialLoadingScreen(),
      ),
    );
  }
}

class InitialLoadingScreen extends StatelessWidget {
  const InitialLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animation/loading.json', width: 150),
            ),
      ),
    );
  }
}