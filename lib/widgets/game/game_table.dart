import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    print('building game_table');

    final moves = Provider.of<List<GameMoves>>(context);

    List<GameCard> previousCards = moves.length > 1 ? moves[1].cards : [];
    List<GameCard> latestCards = moves.isNotEmpty ? moves[0].cards : [];

    return Container(
      width: mediaQuery.size.width * 0.6,
      height: mediaQuery.size.height / 2 * 0.5,
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.secondary.withOpacity(0.2),
            theme.colorScheme.secondary.withOpacity(0)
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.secondary,
          width: 0.7,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: LayoutBuilder(
        builder: (ctx, contraints) => Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
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
