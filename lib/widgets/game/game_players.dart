import 'package:flutter/material.dart';

import '../../services/database.service.dart';
import 'game_user.dart';

class GamePlayers extends StatelessWidget {
  final String gameId;
  final String userId;

  const GamePlayers({
    Key? key,
    required this.gameId,
    required this.userId,
  }) : super(key: key);

  List<Widget> buildPlayers(Map<String, dynamic> gameData) {
    final playerIds = gameData['playerIds'];
    final players = gameData['players'];
    final activePlayerId = gameData['activePlayerId'];
    final List<Widget> gameUsers = [];

    for (var id in playerIds) {
      bool isActive = activePlayerId == id;
      final player = players[id];
      if (player != null) {
        gameUsers.add(
          GameUser(
            cards: players[id]['cardCount'],
            nickname: userId == id ? 'Me' : players[id]['nickname'],
            isActive: isActive,
          ),
        );
      }
    }
    return gameUsers;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocStream>(
      stream: DatabaseService.getGameStream(gameId),
      builder: (context, gameSnapshot) {
        if (gameSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (!gameSnapshot.data!.exists) {
          return const Center(
            child: Text('Error has occurred - try again later'),
          );
        }
        final gameData = gameSnapshot.data!.data();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildPlayers(gameData!),
        );
      },
    );
  }
}
