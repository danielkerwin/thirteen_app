import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/game.model.dart';
import '../../models/game_card.model.dart';
import '../../models/game_moves.model.dart';
import '../../providers/game_moves.provider.dart';
import '../main/loading.dart';
import 'game_card_item.dart';

class GameTable extends ConsumerWidget {
  final Game game;
  const GameTable({
    Key? key,
    required this.game,
  }) : super(key: key);

  List<Widget> _buildCardsOnTable(
    List<GameCard> cards,
    BoxConstraints constraints,
    MediaQueryData mediaQuery,
    bool isPrevious,
  ) {
    double offset = 0.0;
    var modifier = (constraints.maxWidth - 100) / max(5, cards.length);
    final scale = mediaQuery.orientation == Orientation.portrait ? 0.7 : 0.5;
    final topModifier = mediaQuery.orientation == Orientation.portrait
        ? constraints.maxHeight * 0.15
        : constraints.maxHeight * 0.10 - 20;
    return cards.map(
      (card) {
        final widget = Positioned(
          left: 0 + (modifier * offset),
          top: isPrevious ? constraints.maxHeight * 0.1 - 70 : topModifier,
          child: Transform(
            origin: const Offset(65, 100),
            transform: Matrix4.rotationZ(-0.6 + offset / cards.length)
              ..scale(isPrevious ? scale * 0.75 : scale)
              ..translate(1.5),
            child: Opacity(
              opacity: isPrevious ? 0.5 : 1.0,
              child: GameCardItem(
                key: ValueKey(card.id),
                label: card.label,
                color: card.color,
                icon: card.icon,
                selectedIcon: card.icon,
              ),
            ),
          ),
        );
        offset += 1;
        return widget;
      },
    ).toList();
  }

  List<GameMoves> _filterRound(Game? game, List<GameMoves>? moves) {
    if (game == null || moves == null) {
      return [];
    }
    return moves.where((move) => move.round >= game.round).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    final movesAsync = ref.watch(gameMovesProvider(game.id));

    return movesAsync.when(
      error: (err, stack) => const Center(
        child: Text('Error'),
      ),
      loading: () => const Loading(),
      data: (moves) {
        final roundMoves = _filterRound(game, moves);
        List<GameCard> previousCards =
            roundMoves.length > 1 ? roundMoves[1].cards : [];
        List<GameCard> latestCards =
            roundMoves.isNotEmpty ? roundMoves[0].cards : [];

        return Container(
          width: mediaQuery.size.width * 0.6,
          height: mediaQuery.size.height / 2 * 0.5,
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            border: Border.all(
              color: game.isActivePlayer
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
              width: 0.7,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: LayoutBuilder(
            builder: (ctx, contraints) => Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (latestCards.isEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!game.isActive)
                        Text(
                          'Waiting for ${game.createdByName} to start the game',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.secondary,
                          ),
                        )
                      else ...[
                        Text(
                          'Round ${game.round}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: game.isActivePlayer
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                          ),
                        ),
                        Text(
                          '${game.activePlayerName} starts',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: game.isActivePlayer
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                          ),
                        )
                      ]
                    ],
                  ),
                ..._buildCardsOnTable(
                  previousCards,
                  contraints,
                  mediaQuery,
                  true,
                ),
                ..._buildCardsOnTable(
                  latestCards,
                  contraints,
                  mediaQuery,
                  false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
