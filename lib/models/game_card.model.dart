import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum GameCardSuit { spade, club, diamond, heart }

class GameCardValue {
  final String label;
  final int value;
  const GameCardValue({
    required this.label,
    required this.value,
  });
}

const gameCardValues = [
  GameCardValue(label: '3', value: 1),
  GameCardValue(label: '4', value: 2),
  GameCardValue(label: '5', value: 3),
  GameCardValue(label: '6', value: 4),
  GameCardValue(label: '7', value: 5),
  GameCardValue(label: '8', value: 6),
  GameCardValue(label: '9', value: 7),
  GameCardValue(label: '10', value: 8),
  GameCardValue(label: 'J', value: 9),
  GameCardValue(label: 'Q', value: 10),
  GameCardValue(label: 'K', value: 11),
  GameCardValue(label: 'A', value: 12),
  GameCardValue(label: '2', value: 13),
];

class GameCard extends GameCardValue {
  late GameCardSuit suit;
  late Color color;
  late IconData icon;
  late String id;

  GameCard({
    required String label,
    required int cardvalue,
    required int suitValue,
  }) : super(label: label, value: cardvalue) {
    id = '${cardvalue}_$suitValue';
    switch (suitValue) {
      case 0:
        suit = GameCardSuit.club;
        color = Colors.black;
        icon = FontAwesomeIcons.lightClub;
        break;
      case 1:
        suit = GameCardSuit.spade;
        color = Colors.black;
        icon = FontAwesomeIcons.lightSpade;
        break;
      case 2:
        suit = GameCardSuit.diamond;
        color = Colors.red;
        icon = FontAwesomeIcons.lightDiamond;
        break;
      case 3:
        suit = GameCardSuit.heart;
        color = Colors.red;
        icon = FontAwesomeIcons.lightHeart;
        break;
    }
  }
}
