// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:levelup_life/providers/character_notifier.dart';
import 'package:levelup_life/providers/quest_notifier.dart';
import 'package:levelup_life/providers/skill_notifier.dart';
import 'package:levelup_life/screens/profile_screen.dart';
import 'package:levelup_life/screens/quests_screen.dart';
import 'package:levelup_life/screens/skills_screen.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      logger.i('Starting data load...');
      
      // Добавляем таймаут 10 секунд
      await Future.wait([
        context.read<CharacterNotifier>().loadData(),
        context.read<QuestNotifier>().loadData(),
        context.read<SkillNotifier>().loadData(),
      ]).timeout(const Duration(seconds: 10));
      
      logger.i('Data loaded successfully');
    } catch (e) {
      logger.e('Error loading data: $e');
    }
    
    logger.i('Setting loading to false');
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final activeQuestCount = context.select((QuestNotifier n) => n.activeQuestCount);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [ProfileScreen(), QuestsScreen(), SkillsScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Профиль'),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text(activeQuestCount.toString()),
              isLabelVisible: activeQuestCount > 0,
              child: const Icon(Icons.list_alt_rounded),
            ),
            label: 'Квесты',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.account_tree_rounded), label: 'Навыки'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}