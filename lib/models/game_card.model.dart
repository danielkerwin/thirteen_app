import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum GameCardSuit { spade, club, diamond, heart }

final gameCardValueMap = {
  9: 'J',
  10: 'Q',
  11: 'K',
  12: 'A',
  13: '2',
};

class GameCardValue {
  final int value;
  late String label;
  GameCardValue({required this.value}) {
    if (value <= 8) {
      label = '${value + 2}';
    } else {
      label = gameCardValueMap[value]!;
    }
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
    switch (suitValue) {
      case 0:
        suit = GameCardSuit.spade;
        color = Colors.black;
        icon = FontAwesomeIcons.lightSpade;
        selectedIcon = FontAwesomeIcons.solidSpade;
        break;
      case 1:
        suit = GameCardSuit.club;
        color = Colors.black;
        icon = FontAwesomeIcons.lightClub;
        selectedIcon = FontAwesomeIcons.solidClub;
        break;
      case 2:
        suit = GameCardSuit.diamond;
        color = Colors.red;
        icon = FontAwesomeIcons.lightDiamond;
        selectedIcon = FontAwesomeIcons.solidDiamond;
        break;
      case 3:
        suit = GameCardSuit.heart;
        color = Colors.red;
        icon = FontAwesomeIcons.lightHeart;
        selectedIcon = FontAwesomeIcons.solidHeart;
        break;
    }
  }
}
