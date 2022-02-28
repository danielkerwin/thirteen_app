import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game.model.dart';
import '../models/tab_item.model.dart';
import '../services/database.service.dart';
import 'create_game.screen.dart';
import 'game.screen.dart';
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

  final _gameCodeController = TextEditingController();
  int _selectedIndex = 0;

  void _selectScreen(BuildContext context, int index) {
    setState(() => _selectedIndex = index);
  }

  void _createGame() {
    Navigator.of(context).pushNamed(CreateGameScreen.routeName);
  }

  void _joinGame() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          contentPadding: const EdgeInsets.all(16.0),
          children: [
            TextField(
              onChanged: (value) => setState(() {}),
              controller: _gameCodeController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                labelText: 'Enter Game Code',
                prefixText: '#',
              ),
              maxLength: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _gameCodeController.text.length == 5
                  ? () {
                      Navigator.of(context).pushNamed(
                        '${GameScreen.routeName}?id=${_gameCodeController.text.toUpperCase()}',
                      );
                      _gameCodeController.clear();
                    }
                  : null,
              child: const Text('Join Game'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _tabs.addAll([
      TabItem(
        screen: StreamProvider<List<Game>>.value(
          initialData: const [],
          value: DatabaseService.getGamesStream(userId),
          child: const GamesScreen(),
        ),
        title: 'title',
      ),
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
