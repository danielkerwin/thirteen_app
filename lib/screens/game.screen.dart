import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game.provider.dart';
import '../services/database.service.dart';
import '../widgets/game/game_error.dart';
import '../widgets/game/game_hand.dart';
import '../widgets/game/game_join.dart';
import '../widgets/game/game_players.dart';
import '../widgets/game/game_start.dart';
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
    final handHeight = mediaQuery.size.height * 0.30;
    final gameId = ModalRoute.of(context)?.settings.arguments as String?;

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
          : StreamBuilder<DocStream>(
              stream: DatabaseService.getGameStream(gameId),
              builder: (context, gameSnapshot) {
                if (gameSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (gameSnapshot.hasError) {
                  return GameError(gameId: gameId);
                }
                if (!gameSnapshot.data!.exists) {
                  return GameError(gameId: gameId);
                }
                final userId = FirebaseAuth.instance.currentUser?.uid;
                final gameData = gameSnapshot.data!.data();
                final playerCount = gameData!['playerIds'].length;
                final status = gameData['status'];
                final myData = gameData['players'][userId];

                final isCreatedByMe = gameData['createdById'] == userId;

                return Container(
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
                      Expanded(
                        child: Consumer<Game>(
                          builder: (_, game, __) => GameTable(
                            cards: game.cardsOnTable,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (myData == null) GameJoin(gameId: gameId),
                      if (isCreatedByMe && status == 0)
                        GameStart(
                          gameId: gameId,
                          isDisabled: playerCount < 4,
                        ),
                      SizedBox(
                        height: handHeight,
                        child: GameHand(
                          gameId: gameId,
                          userId: userId,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
