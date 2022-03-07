import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../models/tab_item.model.dart';
import 'create_game.screen.dart';
import 'games.screen.dart';
import 'scoreboard.screen.dart';
import 'settings.screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<TabItem> _tabs = [];

  int _selectedIndex = 0;

  void _selectScreen(BuildContext context, int index) {
    setState(() => _selectedIndex = index);
  }

  void _createGame() {
    Navigator.of(context).pushNamed(CreateGameScreen.routeName);
  }

  void _joinGame() {
    Helpers.openJoinGameDialog(context);
  }

  @override
  void initState() {
    super.initState();
    _tabs.addAll([
      const TabItem(screen: GamesScreen(), title: 'title'),
      const TabItem(screen: ScoreboardScreen(), title: 'title'),
      const TabItem(screen: SettingsScreen(), title: 'title')
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thirteen!',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
        actions: [
          TextButton(
            child: const Text(
              'JOIN GAME',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _joinGame,
          ),
        ],
      ),
      body: _tabs[_selectedIndex].screen,
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              tooltip: 'Create a Game',
              child: const Icon(Icons.add),
              onPressed: _createGame,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) => _selectScreen(context, idx),
        backgroundColor: theme.primaryColor,
        unselectedItemColor: theme.primaryColorLight,
        selectedItemColor: theme.colorScheme.onSecondary,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Scoreboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
