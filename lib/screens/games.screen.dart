import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';
import '../models/game.model.dart';
import 'game.screen.dart';
import '../widgets/main/loading.dart';

class GamesScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    print('loading games_screen');
    final theme = Theme.of(context);
    final gamesAsync = ref.watch(gamesProvider);

    return gamesAsync.when(
      error: (err, stack) => const Center(child: Text('Error')),
      loading: () => const Loading(),
      data: (games) => ListView.builder(
        itemCount: games.length,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        itemBuilder: (ctx, idx) {
          final game = games[idx];

          final turnMessage = game.isActivePlayer
              ? 'YOUR TURN'
              : '${game.activePlayerName}\'s turn'.toUpperCase();

          return Card(
            child: Dismissible(
              key: ValueKey(game.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                ref.read(databaseProvider)!.deleteGame(game.id);
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
                trailing: game.isActive
                    ? Text(
                        turnMessage,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: game.isActivePlayer
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '${GameScreen.routeName}?id=${game.id}',
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
