import 'package:flutter/material.dart';

import '../models/game_card.model.dart';
import 'game_card_item.dart';

class GameTable extends StatelessWidget {
  final List<GameCard> cards;
  const GameTable({Key? key, required this.cards}) : super(key: key);

  List<Widget> _buildTable(BoxConstraints constraints) {
    double offset = 0.0;
    return cards.map(
      (card) {
        final widget = Positioned(
          left: offset * 13,
          child: Transform(
            origin: const Offset(65, 100),
            transform: Matrix4.rotationZ(-0.6 + offset / 7)..scale(0.7),
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
    print('building game_table');
    return Container(
      width: mediaQuery.size.width * 0.5,
      height: mediaQuery.size.height / 2 * 0.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: LayoutBuilder(
        builder: (ctx, contraints) => Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: _buildTable(contraints),
        ),
      ),
    );
  }
}
