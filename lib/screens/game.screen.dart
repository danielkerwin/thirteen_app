import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/game/game_hand.dart';
import '../widgets/game/game_manager.dart';
import '../widgets/game/game_players.dart';
import '../widgets/game/game_table.dart';

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
    final handHeight = mediaQuery.size.height * 0.35;
    final gameId = ModalRoute.of(context)?.settings.arguments as String?;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thirteen!',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
        actions: [
          if (gameId != null)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Center(
                child: SelectableText(
                  '#$gameId',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            )
        ],
      ),
      body: gameId == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Missing Game Code'),
                  TextButton(
                    child: const Text('Go back'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            )
          : Container(
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
                  GamePlayers(gameId: gameId, userId: userId!),
                  const SizedBox(height: 5),
                  Expanded(child: GameTable(gameId: gameId)),
                  const SizedBox(height: 20),
                  GameManager(gameId: gameId, userId: userId),
                  SizedBox(
                    height: handHeight,
                    child: GameHand(
                      gameId: gameId,
                      userId: userId,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
