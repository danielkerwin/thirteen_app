import 'package:flutter/material.dart';

import '../models/game_card.model.dart';
import 'game_card_item.dart';

class GameTable extends StatelessWidget {
  final List<GameCard> cards;
  const GameTable({Key? key, required this.cards}) : super(key: key);

  List<Widget> _buildTable(BoxConstraints constraints) {
    print(constraints.widthConstraints());
    double offset = 0.0;
    return cards.map(
      (card) {
        final widget = Positioned(
          left: offset * 10,
          child: Transform(
            origin: const Offset(65, 100),
            transform: Matrix4.rotationZ(-0.6 + offset / 10)..scale(0.6),
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
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
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
