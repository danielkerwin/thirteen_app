import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game.provider.dart';
import '../widgets/game_hand.dart';
import '../widgets/game_table.dart';
import '../widgets/game_opponents.dart';
import '../widgets/game_user.dart';

class GameScreen extends StatelessWidget {
  static const routeName = '/game';
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
          'Playing Thirteen!',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
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
    );
  }
}
