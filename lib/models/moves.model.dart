import 'package:cloud_firestore/cloud_firestore.dart';

import 'game_card.model.dart';

class GameMoves {
  final List<GameCard> cards;

  const GameMoves({required this.cards});

  factory GameMoves.fromEmpty() {
    return const GameMoves(cards: []);
  }

  factory GameMoves.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    List<dynamic> cards = data['cards'] ?? [];
    return GameMoves(
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
