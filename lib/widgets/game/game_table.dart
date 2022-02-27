import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/game_card.model.dart';
import '../../services/database.service.dart';
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
    return cards.map(
      (card) {
        final widget = Positioned(
          left: 0 + (modifier * offset),
          top: isPrevious
              ? constraints.maxHeight * 0.1 - 60
              : constraints.maxHeight * 0.15,
          child: Transform(
            origin: const Offset(65, 100),
            transform: Matrix4.rotationZ(-0.6 + offset / cards.length)
              ..scale(isPrevious ? scale * 0.75 : scale)
              ..translate(1.5),
            child: Opacity(
              opacity: isPrevious ? 0.5 : 1.0,
              child: GameCardItem(
                label: card.label,
                color: card.color,
                icon: card.icon,
              ),
            ),
          ),
        );
        offset += 1;
        return widget;
      },
    ).toList();
  }

  Stream<CollectionStream> get _getMovesStream {
    return DatabaseService.getMovesStream(gameId);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    print('building game_table');

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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: StreamBuilder<CollectionStream>(
        stream: _getMovesStream,
        builder: (context, movesSnapshot) {
          if (movesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          final previousMove = movesSnapshot.data!.docs.length > 1
              ? movesSnapshot.data!.docs[1].data()
              : {};
          final lastMove = movesSnapshot.data!.docs.isNotEmpty
              ? movesSnapshot.data!.docs[0].data()
              : {};

          final previousCards = (previousMove.isNotEmpty
              ? previousMove['cards']
              : []) as List<dynamic>;
          final lastCards =
              (lastMove.isNotEmpty ? lastMove['cards'] : []) as List<dynamic>;

          final previousGameCards = previousCards.map((card) {
            return GameCard(
              cardvalue: card['value'],
              suitValue: card['suit'],
            );
          }).toList();

          final lastGameCards = lastCards.map((card) {
            return GameCard(
              cardvalue: card['value'],
              suitValue: card['suit'],
            );
          }).toList();

          return LayoutBuilder(
            builder: (ctx, contraints) => Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                ..._buildCardsOnTable(
                  previousGameCards,
                  contraints,
                  mediaQuery,
                  true,
                ),
                ..._buildCardsOnTable(
                  lastGameCards,
                  contraints,
                  mediaQuery,
                  false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
