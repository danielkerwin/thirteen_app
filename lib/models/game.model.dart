import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/database.service.dart';
import 'player.model.dart';

enum GameStatus { created, active, complete }

class Game {
  final String id;
  final DateTime createdAt;
  final String createdById;
  final String createdByName;
  final String activePlayerId;
  final List<String> playerIds;
  final GameStatus status;
  final Map<String, PlayerInfo> players;
  final List<String> rankIds;
  final int round;
  final int turn;
  final String userId;

  Game({
    required this.status,
    required this.id,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
    required this.activePlayerId,
    required this.playerIds,
    required this.players,
    required this.rankIds,
    required this.round,
    required this.turn,
    required this.userId,
  });

  bool get isCreatedByMe {
    return userId == createdById;
  }

  bool get isJoined {
    return players[userId] != null;
  }

  bool get isActivePlayer {
    return activePlayerId == userId;
  }

  bool get isWinner {
    return rankIds.isNotEmpty ? rankIds[0] == userId : false;
  }

  bool get isSkippedRound {
    return (players[userId]?.round ?? 0) > round;
  }

  bool get isActive {
    return status == GameStatus.active;
  }

  bool get isCreated {
    return status == GameStatus.created;
  }

  bool get isComplete {
    return status == GameStatus.complete;
  }

  String get winningPlayerName {
    return players[rankIds[0]]?.nickname ?? 'someone';
  }

  String get activePlayerName {
    return players[activePlayerId]?.nickname ?? 'someone';
  }

  static GameStatus _getStatus(int status) {
    switch (status) {
      case 0:
        return GameStatus.created;
      case 1:
        return GameStatus.active;
      case 2:
        return GameStatus.complete;
      default:
        return GameStatus.created;
    }
  }

  factory Game.fromEmpty() {
    return Game(
      id: '',
      activePlayerId: '',
      createdAt: DateTime.now(),
      createdById: '',
      createdByName: '',
      playerIds: [],
      players: {},
      status: GameStatus.created,
      rankIds: [],
      round: 1,
      turn: 1,
      userId: '',
    );
  }

  factory Game.fromFirestore(DocSnapshot doc, String userId) {
    Map<String, dynamic> gameData = doc.data() ?? {};
    final status = _getStatus(gameData['status'] ?? 0);
    Map<String, dynamic> players = gameData['players'] ?? {};
    List<dynamic> playerIds = gameData['playerIds'] ?? [];
    List<dynamic> rankIds = gameData['rankIds'] ?? [];
    Timestamp createdAt = gameData['createdAt'] ?? Timestamp.now();
    return Game(
      id: doc.id,
      activePlayerId: gameData['activePlayerId'] ?? '',
      createdAt: createdAt.toDate(),
      createdById: gameData['createdById'] ?? '',
      createdByName: gameData['createdByName'] ?? '',
      playerIds: playerIds.map((id) => id.toString()).toList(),
      players: players.map((key, player) {
        return MapEntry(
          key,
          PlayerInfo(
            cardCount: player['cardCount'] ?? 0,
            round: player['round'] ?? 0,
            nickname: player['nickname'] ?? '',
          ),
        );
      }),
      status: status,
      rankIds: rankIds.map((id) => id.toString()).toList(),
      round: gameData['round'] ?? 1,
      turn: gameData['turn'] ?? 1,
      userId: userId,
    );
  }
}
