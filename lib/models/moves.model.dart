import 'package:cloud_firestore/cloud_firestore.dart';

import 'game_card.model.dart';

class GameMoves {
  final List<GameCard> cards;
  final int round;

  const GameMoves({
    required this.cards,
    required this.round,
  });

  factory GameMoves.fromEmpty() {
    return const GameMoves(cards: [], round: 1);
  }

  factory GameMoves.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    List<dynamic> cards = data['cards'] ?? [];

    return GameMoves(
      round: data['round'] ?? 0,
      cards: cards
          .map(
            (card) => GameCard(
              cardvalue: card['value'],
              suitValue: card['suit'],
            ),
          )
          .toList(),
    );
  }
}
