import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_card.model.dart';
import '../providers/game.provider.dart';
import '../providers/ui.provider.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/game_hand.dart';
import '../widgets/game_table.dart';
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
        title: const Text('Thirteen!'),
        actions: [
          IconButton(
            onPressed: () => _shuffleCards(context),
            icon: const Icon(Icons.shuffle),
          ),
          IconButton(
            icon: Icon(ui.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: ui.toggleDarkMode,
          ),
        ],
      ),
      body: Container(
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
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Player 3...'),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Player 2...'),
                        Consumer<Game>(
                          builder: (_, game, __) => GameTable(
                            cards: game.cardsOnTable,
                          ),
                        ),
                        const Text('Player 4...'),
                      ],
                    ),
                  ),
                ],
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
