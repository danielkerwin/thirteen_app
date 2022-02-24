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
  final GameCardSuit suit;
  final Color color;
  final IconData icon;
  late String id;

  GameCard({
    label,
    value,
    required this.suit,
    required this.color,
    required this.icon,
  }) : super(label: label, value: value) {
    id = '${suit.index}_$value';
  }
}

final gameCards = [
  ...gameCardValues.map(
    (card) => GameCard(
      label: card.label,
      value: card.value,
      suit: GameCardSuit.club,
      icon: FontAwesomeIcons.lightClub,
      color: Colors.black,
    ),
  ),
  ...gameCardValues.map(
    (card) => GameCard(
      label: card.label,
      value: card.value,
      suit: GameCardSuit.spade,
      icon: FontAwesomeIcons.lightSpade,
      color: Colors.black,
    ),
  ),
  ...gameCardValues.map(
    (card) => GameCard(
      label: card.label,
      value: card.value,
      suit: GameCardSuit.diamond,
      icon: FontAwesomeIcons.lightDiamond,
      color: Colors.red,
    ),
  ),
  ...gameCardValues.map(
    (card) => GameCard(
      label: card.label,
      value: card.value,
      suit: GameCardSuit.heart,
      icon: FontAwesomeIcons.lightHeart,
      color: Colors.red,
    ),
  ),
];
