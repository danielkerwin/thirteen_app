import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/player.model.dart';
import 'game_hand_cards.dart';

class GameHand extends StatelessWidget {
  final String gameId;
  final String userId;

  const GameHand({
    Key? key,
    required this.gameId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building game_hand');

    final playerHand = Provider.of<PlayerHand>(context);

    if (playerHand.cards.isEmpty) {
      return const Center(
        child: Text('Waiting for game to start...'),
      );
    }

    return GameHandCards(gameId: gameId, cards: playerHand.cards);
  }
}
