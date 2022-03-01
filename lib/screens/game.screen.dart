import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.model.dart';
import '../widgets/game/game_hand.dart';
import '../widgets/game/game_manager.dart';
import '../widgets/game/game_players.dart';
import '../widgets/game/game_table.dart';

class GameScreen extends StatelessWidget {
  static const routeName = '/game';
  final String gameId;
  const GameScreen({
    Key? key,
    required this.gameId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building game_screen');
    final theme = Theme.of(context);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thirteen!',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
        actions: [
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
            GamePlayers(gameId: gameId, userId: userId!),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [GameTable(gameId: gameId)],
            ),
            GameManager(gameId: gameId, userId: userId),
            Expanded(
              child: Consumer<PlayerHand>(
                builder: (_, playerHand, __) => GameHand(
                  gameId: gameId,
                  cards: playerHand.cards,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
