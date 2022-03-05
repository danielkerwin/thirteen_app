import 'package:flutter/material.dart';

import '../constants/game.constants.dart';

class GameCardValue {
  final int value;
  late String label;
  GameCardValue({required this.value}) {
    label = gameCardValueMap[value]!;
  }
}

class GameCard extends GameCardValue {
  late GameCardSuit suit;
  late Color color;
  late IconData icon;
  late IconData selectedIcon;
  late String id;

  GameCard({
    required int cardvalue,
    required int suitValue,
  }) : super(value: cardvalue) {
    id = '${cardvalue}_$suitValue';
    suit = GameCardSuit.values[suitValue];
    color = GameCardSuit.values[suitValue].color;
    icon = GameCardSuit.values[suitValue].icon;
    selectedIcon = GameCardSuit.values[suitValue].selectedIcon;
  }
}
