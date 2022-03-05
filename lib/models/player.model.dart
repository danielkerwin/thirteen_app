import '../services/database.service.dart';
import 'game_card.model.dart';

class PlayerInfo {
  final int cardCount;
  final int round;
  final String nickname;

  const PlayerInfo({
    required this.cardCount,
    required this.round,
    required this.nickname,
  });
}

class PlayerHand {
  final List<GameCard> cards;

  const PlayerHand({required this.cards});

  factory PlayerHand.fromEmpty() {
    return const PlayerHand(cards: []);
  }

  factory PlayerHand.fromFirestore(DocSnapshot doc) {
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
