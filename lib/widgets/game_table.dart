import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_card.model.dart';
import 'game_card_item.dart';

class GameTable extends StatelessWidget {
  final List<GameCard> cards;
  const GameTable({Key? key, required this.cards}) : super(key: key);

  List<Widget> _buildTable() {
    int offset = 0;
    return cards.map(
      (card) {
        final widget = Positioned(
          left: offset * 15,
          child: Transform(
            origin: const Offset(65, 100),
            transform: Matrix4.rotationZ(-0.6 + offset / 10),
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
    print('building game_table');
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: _buildTable(),
      ),
    );
  }
}
