import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/game/game_hand.dart';
import '../widgets/game/game_manager.dart';
import '../widgets/game/game_players.dart';
import '../widgets/game/game_table.dart';
import '../widgets/main/loading.dart';

class GameScreen extends ConsumerWidget {
  static const routeName = '/game';
  final String gameId;
  const GameScreen({
    Key? key,
    required this.gameId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('building game_screen');
    final theme = Theme.of(context);
    final gameAsync = ref.watch(gameProvider(gameId));

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
      body: gameAsync.when(
        error: (err, stack) => const Center(child: Text('Error')),
        loading: () => const Loading(),
        data: (game) => Container(
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
              GamePlayers(game: game),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [GameTable(game: game)],
              ),
              GameManager(game: game),
              Expanded(
                child: GameHand(
                  game: game,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
