import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game.provider.dart';
import '../services/database.service.dart';
import '../widgets/game/game_error.dart';
import '../widgets/game/game_hand.dart';
import '../widgets/game/game_players.dart';
import '../widgets/game/game_table.dart';
import '../widgets/game/game_user.dart';

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
    final gameId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Playing Thirteen!',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: DatabaseService.getGameStream(gameId),
          builder: (context, gameSnapshot) {
            if (gameSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (gameSnapshot.hasError) {
              return GameError(gameId: gameId);
            }
            if (!gameSnapshot.data!.exists) {
              return GameError(gameId: gameId);
            }
            final userId = FirebaseAuth.instance.currentUser?.uid;
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
                  GamePlayers(gameId: gameId, userId: userId as String),
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
                    mainAxisAlignment:
                        mediaQuery.orientation == Orientation.portrait
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                    children: [
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream:
                            DatabaseService.getGamePlayerStream(gameId, userId),
                        builder: (context, gamePlayerSnapshot) {
                          if (gamePlayerSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                          return GameUser(
                            nickname: 'Me',
                            cards: gamePlayerSnapshot.data?['cardsCount'],
                          );
                        },
                      )
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      child: const Text('Start game'),
                      onPressed: Provider.of<Game>(context, listen: false)
                          .generateNewCards,
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: handHeight,
                    child: const GameHand(),
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: IconButton(
        onPressed: Provider.of<Game>(context, listen: false).sortCards,
        icon: const Icon(Icons.sort),
        color: theme.colorScheme.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
