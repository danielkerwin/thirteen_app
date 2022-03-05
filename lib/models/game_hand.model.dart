import '../services/database.service.dart';
import 'game_card.model.dart';

class GameHand {
  final List<GameCard> cards;

  const GameHand({required this.cards});

  factory GameHand.fromFirestore(DocSnapshot doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    List<dynamic> cards = data['cards'] ?? [];
    return GameHand(
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
