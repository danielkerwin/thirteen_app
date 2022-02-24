import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_card.model.dart';
import '../providers/game.provider.dart';
import '../providers/ui.provider.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/game_hand.dart';
import '../widgets/game_table.dart';
import '../widgets/game_opponents.dart';
import '../widgets/game_user.dart';
import '../widgets/side_drawer.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    Key? key,
  }) : super(key: key);

  void _shuffleCards(BuildContext context) {
    print('shuffling cards');
    Provider.of<Game>(context, listen: false).generateNewCards();
  }

  @override
  Widget build(BuildContext context) {
    print('building game_screen');
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final ui = Provider.of<UI>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thirteen!',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
        actions: [
          IconButton(
            onPressed: () => _shuffleCards(context),
            icon: const Icon(Icons.shuffle),
          ),
          IconButton(
            icon: Icon(ui.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: ui.toggleDarkMode,
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
            Consumer<Game>(
              builder: (_, game, __) => GameUser(
                username: 'Daniel',
                cards: game.cardsInHand.length,
              ),
            ),
            SizedBox(
              height:
                  mediaQuery.orientation == Orientation.landscape ? 150 : 300,
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
          : const SideDrawer(),
      bottomNavigationBar: mediaQuery.orientation == Orientation.portrait
          ? const BottomNav()
          : null,
    );
  }
}
