import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/game.model.dart';
import '../../models/game_card.model.dart';
import '../../models/moves.model.dart';
import 'game_card_item.dart';

class GameTable extends StatelessWidget {
  final String gameId;
  const GameTable({
    Key? key,
    required this.gameId,
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

  List<GameMoves> _filterRound(Game game, List<GameMoves> moves) {
    return moves.where((move) => move.round >= game.round).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    print('building game_table');

    final moves = Provider.of<List<GameMoves>>(context);
    final game = Provider.of<Game>(context);

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
                  Text(
                    'Round ${game.round}',
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
                    style: TextStyle(
                      fontSize: 16,
                      color: game.isActivePlayer
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                  )
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
  }
}
