import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/game_card.model.dart';
import '../../providers/game.provider.dart';
import '../../services/database.service.dart';
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

    return StreamBuilder<DocStream>(
      stream: DatabaseService.getPlayerStream(gameId, userId),
      builder: (context, playerStream) {
        if (playerStream.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (!playerStream.data!.exists) {
          return const Center(
            child: Text('Waiting for game to start...'),
          );
        }

        final data = playerStream.data!.data() as Map<String, dynamic>;
        final cards = data['cards'] as List<dynamic>;

        final gameCards = cards.map((card) {
          return GameCard(
            cardvalue: card['value'],
            suitValue: card['suit'],
          );
        }).toList();

        return GameHandCards(gameId: gameId, cards: gameCards);
      },
    );
  }
}
