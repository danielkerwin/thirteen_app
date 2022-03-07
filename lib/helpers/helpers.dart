import 'package:flutter/material.dart';

import '../constants/game.constants.dart';
import '../models/game_card.model.dart';
import '../screens/game.screen.dart';

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

  static Future<void> openJoinGameDialog(BuildContext context) async {
    final _gameCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          contentPadding: const EdgeInsets.all(16.0),
          children: [
            TextField(
              onChanged: (value) => setState(() {}),
              controller: _gameCodeController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                labelText: 'Enter Game Code',
                prefixText: '#',
              ),
              maxLength: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _gameCodeController.text.length == 5
                  ? () {
                      Navigator.of(context).pushNamed(
                        '${GameScreen.routeName}?id=${_gameCodeController.text.toUpperCase()}',
                      );
                      _gameCodeController.clear();
                    }
                  : null,
              child: const Text('Join Game'),
            )
          ],
        ),
      ),
    );
  }
}
