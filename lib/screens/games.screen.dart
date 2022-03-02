import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/game.model.dart';
import '../services/database.service.dart';
import 'game.screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  String _getGameStatus(GameStatus status) {
    switch (status) {
      case GameStatus.created:
        return 'NEW';
      case GameStatus.active:
        return 'ACTIVE';
      case GameStatus.complete:
        return 'COMPLETE';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final theme = Theme.of(context);
    final games = Provider.of<List<Game>>(context);
    return ListView.builder(
      itemCount: games.length,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      itemBuilder: (ctx, idx) {
        final game = games[idx];

        var isMyTurn = game.activePlayerId == userId;
        var activePlayer =
            game.players[game.activePlayerId]?.nickname ?? 'someone';
        var isActive = game.isActive;
        final turnMessage =
            isMyTurn ? 'YOUR TURN' : '$activePlayer\'s turn'.toUpperCase();

        return Card(
          child: Dismissible(
            key: ValueKey(game.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              DatabaseService.deleteGame(game.id);
            },
            background: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              padding: const EdgeInsets.only(right: 16.0),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              title: Text('Game #${game.id}'),
              subtitle: Text(
                '${DateFormat.yMMMd().format(game.createdAt)} - ${_getGameStatus(game.status)}',
              ),
              trailing: isActive
                  ? Text(
                      turnMessage,
                      style: TextStyle(
                        color: isMyTurn
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary,
                      ),
                    )
                  : null,
              onTap: () => Navigator.of(context).pushNamed(
                '${GameScreen.routeName}?id=${game.id}',
              ),
            ),
          ),
        );
      },
    );
  }
}
