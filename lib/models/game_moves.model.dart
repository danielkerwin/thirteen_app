import '../services/database.service.dart';
import 'game_card.model.dart';

class GameMoves {
  final List<GameCard> cards;
  final String userId;
  final int round;

  const GameMoves({
    required this.cards,
    required this.userId,
    required this.round,
  });

  factory GameMoves.fromFirestore(DocSnapshot doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    List<dynamic> cards = data['cards'] ?? [];

    return GameMoves(
      round: data['round'] ?? 0,
      userId: data['userId'] ?? '',
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
