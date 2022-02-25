import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/game_card.model.dart';
import 'game_card_item.dart';

class GameTable extends StatelessWidget {
  final List<GameCard> cards;
  const GameTable({Key? key, required this.cards}) : super(key: key);

  List<Widget> _buildTable(
    BoxConstraints constraints,
    MediaQueryData mediaQuery,
  ) {
    double offset = 0.0;
    var modifier = (constraints.maxWidth - 100) / max(5, cards.length);
    return cards.map(
      (card) {
        final widget = Positioned(
          left: 0 + (modifier * offset),
          child: Transform(
            origin: const Offset(65, 100),
            transform: Matrix4.rotationZ(-0.6 + offset / cards.length)
              ..scale(
                mediaQuery.orientation == Orientation.portrait ? 0.7 : 0.5,
              )
              ..translate(1.5),
            child: GameCardItem(
              label: card.label,
              color: card.color,
              icon: card.icon,
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
            theme.colorScheme.secondary.withOpacity(0.5),
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
      child: LayoutBuilder(
        builder: (ctx, contraints) => Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: _buildTable(contraints, mediaQuery),
        ),
      ),
    );
  }
}
