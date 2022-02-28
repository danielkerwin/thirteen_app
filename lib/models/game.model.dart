import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final Map<String, PlayerData> players;

  Game({
    required this.status,
    required this.id,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
    required this.activePlayerId,
    required this.playerIds,
    required this.players,
  });

  bool get isCreatedByMe {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return userId == createdById;
  }

  bool get isJoined {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return players[userId] != null;
  }

  bool get isActivePlayer {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return activePlayerId == userId;
  }

  bool get isActive {
    return status == GameStatus.active;
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
    );
  }

  factory Game.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> gameData = doc.data() ?? {};
    final status = _getStatus(gameData['status'] ?? 0);
    Map<String, dynamic> players = gameData['players'] ?? {};
    List<dynamic> playerIds = gameData['playerIds'] ?? [];
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
          PlayerData(
            cardCount: player['cardCount'] ?? 0,
            nickname: player['nickname'] ?? '',
          ),
        );
      }),
      status: status,
    );
  }
}
