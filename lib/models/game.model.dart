enum GameStatus { created, active, complete }

class Game {
  final String id;
  final DateTime createdAt;
  final String createdById;
  final String createdByName;
  GameStatus status;

  Game({
    this.status = GameStatus.created,
    required this.id,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
  });
}
