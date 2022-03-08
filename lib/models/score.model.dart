import '../services/database.service.dart';

class Score {
  final String id;
  final int gamesPlayed;
  final int gamesWon;
  final Map<String, Map<String, int>> ranksByPlayers;

  const Score({
    required this.id,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.ranksByPlayers,
  });

  factory Score.fromFirestore(DocSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ranks = data['ranksByPlayers'] as Map<String, dynamic>;
    final ranksByPlayers = ranks.map((players, player) {
      final ranksData = player as Map<String, dynamic>;
      return MapEntry(
        players,
        ranksData.map((rank, count) {
          return MapEntry(rank, count as int);
        }),
      );
    });
    return Score(
      id: doc.id,
      gamesPlayed: data['gamesPlayed'] ?? 0,
      gamesWon: data['gamesWon'] ?? 0,
      ranksByPlayers: ranksByPlayers,
    );
  }
}
