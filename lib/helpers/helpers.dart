import 'package:flutter/material.dart';

import '../constants/game.constants.dart';
import '../models/game_card.model.dart';

class Helpers {
  static SnackBar getSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(fontFamily: 'Roboto'),
      ),
    );
  }

  static bool isSameValue(List<GameCard> cards) {
    final value = cards[0].value;
    return cards.every((card) => card.value == value);
  }

  static bool isSequence(List<GameCard> cards) {
    if (cards.length < 3) {
      return false;
    }
    var value = cards[0].value - 1;
    return cards.every((card) {
      var isSeq = card.value == value + 1;
      value += 1;
      return isSeq;
    });
  }

  static Widget highCard(GameCard card, Color color) {
    return Row(
      children: [
        Text('(${card.label}'),
        const SizedBox(width: 2),
        Icon(
          GameCardSuit.values[card.suit.index].icon,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        const Text('high)'),
      ],
    );
  }
}
