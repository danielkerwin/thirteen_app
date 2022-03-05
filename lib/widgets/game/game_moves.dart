import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/game.constants.dart';
import '../../helpers/helpers.dart';
import '../../models/game.model.dart';
import '../../models/game_card.model.dart';
import '../../providers/game_moves.provider.dart';
import '../main/loading.dart';

class GameMoves extends ConsumerWidget {
  final Game game;
  const GameMoves({
    Key? key,
    required this.game,
  }) : super(key: key);

  GameMoveType _getMoveType(List<GameCard> cards) {
    final len = cards.length;
    if (len == 1) {
      return GameMoveType.single;
    }
    if (len == 2) {
      return GameMoveType.double;
    }
    if (len == 3) {
      if (Helpers.isSameValue(cards)) {
        return GameMoveType.triple;
      }
      return GameMoveType.run;
    }
    if (len == 4) {
      if (Helpers.isSameValue(cards)) {
        return GameMoveType.quad;
      }
      return GameMoveType.run;
    }
    return GameMoveType.run;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameMovesAsync = ref.watch(gameMovesProvider(game.id));
    final theme = Theme.of(context);
    return gameMovesAsync.when(
      loading: () => const Loading(),
      error: (err, stack) => const Center(child: Text('Error')),
      data: (gameMoves) {
        if (gameMoves.isEmpty) {
          return const SizedBox();
        }
        final round = gameMoves[0].round;
        if (round < game.round) {
          return const SizedBox();
        }
        final playerId = gameMoves[0].userId;
        final cards = gameMoves[0].cards;
        final lastCard = cards[cards.length - 1];
        final player = game.players[playerId]?.nickname ?? 'someone';

        final moveType = _getMoveType(cards);
        final desc =
            GameMoveType.values[moveType.index].description(cards.length);

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$player played a'),
                  const SizedBox(width: 3),
                  Text(
                    desc,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Helpers.highCard(lastCard),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
