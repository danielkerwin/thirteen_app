import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game.provider.dart';
import '../providers/ui.provider.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/game_hand.dart';
import '../widgets/game_table.dart';
import '../widgets/game_opponents.dart';
import '../widgets/game_user.dart';
import '../widgets/main_drawer.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building game_screen');
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final handHeight = mediaQuery.size.height * 0.30;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thirteen!',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
        actions: [
          IconButton(
            onPressed:
                Provider.of<Game>(context, listen: false).generateNewCards,
            icon: const Icon(Icons.shuffle),
          ),
          Consumer<UI>(
            builder: (_, ui, __) => IconButton(
              icon: Icon(ui.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: ui.toggleDarkMode,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: FirebaseAuth.instance.signOut,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0),
              theme.primaryColor.withOpacity(0.5),
            ],
          ),
        ),
        child: Column(
          children: [
            const GameOpponents(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Consumer<Game>(
                builder: (_, game, __) => GameTable(
                  cards: game.cardsOnTable,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: mediaQuery.orientation == Orientation.portrait
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Consumer<Game>(
                  builder: (_, game, __) => GameUser(
                    username: 'Me',
                    cards: game.cardsInHand.length,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: handHeight,
              child: const GameHand(),
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: Provider.of<Game>(context, listen: false).sortCards,
        icon: const Icon(Icons.sort),
        color: theme.colorScheme.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      drawer: mediaQuery.orientation == Orientation.portrait
          ? null
          : const MainDrawer(),
      bottomNavigationBar: mediaQuery.orientation == Orientation.portrait
          ? const MainBottomNav()
          : null,
    );
  }
}
