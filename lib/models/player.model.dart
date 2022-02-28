import 'package:cloud_firestore/cloud_firestore.dart';

import 'game_card.model.dart';

class PlayerData {
  final int cardCount;
  final String nickname;

  const PlayerData({
    required this.cardCount,
    required this.nickname,
  });
}

class PlayerHand {
  final List<GameCard> cards;

  const PlayerHand({required this.cards});

  factory PlayerHand.fromEmpty() {
    return const PlayerHand(cards: []);
  }

  factory PlayerHand.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    List<dynamic> cards = data['cards'] ?? [];
    return PlayerHand(
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
