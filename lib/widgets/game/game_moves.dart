import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/game.model.dart';
import '../../providers/game_moves.provider.dart';
import '../main/loading.dart';

class GameMoves extends ConsumerWidget {
  final Game game;
  const GameMoves({
    Key? key,
    required this.game,
  }) : super(key: key);

  _getCardDescription() {
    return FontAwesomeIcons();
  }

  String _getMoveType(int length) {
    switch (length) {
      case 1:
        return 'single';
      case 2:
        return 'double';
      case 3:
        return 'triple';
      case 4:
        return 'sequence';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameMovesAsync = ref.watch(gameMovesProvider(game.id));
    final theme = Theme.of(context);
    return gameMovesAsync.when(
      loading: () => const Loading(),
      error: (err, stack) => const Center(
        child: Text('Error'),
      ),
      data: (gameMoves) {
        final playerId = gameMoves[0].userId;
        final cards = gameMoves[0].cards;
        final card = cards[0];

        final isMe = playerId == game.userId;
        final player =
            isMe ? 'Me' : game.players[playerId]?.nickname ?? 'someone';

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              player,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 4),
            const Text('played a'),
            const SizedBox(width: 4),
            Text(
              _getMoveType(cards.length),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '9 of ${card.suit.name}s',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
          ],
        );
      },
    );
  }
}
