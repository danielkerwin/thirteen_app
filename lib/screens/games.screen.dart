import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../helpers/helpers.dart';
import '../providers/database.provider.dart';
import '../providers/game.provider.dart';
import '../widgets/game/game_filter.dart';
import 'create_game.screen.dart';
import 'game.screen.dart';
import '../widgets/main/loading.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gamesAsync = ref.watch(gamesProvider);

    return gamesAsync.when(
      error: (err, stack) => const Center(child: Text('Error')),
      loading: () => const Loading(),
      data: (games) => games.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GameFilter(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'No games',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text(
                              'Create a game',
                              style:
                                  TextStyle(color: theme.colorScheme.secondary),
                            ),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(CreateGameScreen.routeName),
                          ),
                          const Text('or'),
                          TextButton(
                            child: const Text('Join a game'),
                            onPressed: () =>
                                Helpers.openJoinGameDialog(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          : Column(
              children: [
                const GameFilter(),
                Expanded(
                  child: ListView.builder(
                    itemCount: games.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 8.0),
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
                            title: Text(
                              'Game #${game.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${DateFormat.yMMMd().format(game.createdAt)} - ${game.gameStatus}',
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
                                : game.isComplete && game.isWinner
                                    ? const Icon(
                                        FontAwesomeIcons.solidTrophyAlt,
                                        size: 25,
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
                ),
              ],
            ),
    );
  }
}
