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

  List<GameUser> buildPlayers(Map<String, dynamic> data) {
    final List<GameUser> gameUsers = [];
    for (var doc in data.entries) {
      if (doc.key != userId) {
        gameUsers.add(
          GameUser(
            cards: doc.value['cardCount'],
            nickname: doc.value['nickname'],
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
        final data = gameSnapshot.data!.data();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildPlayers(data!['players']),
        );
      },
    );
  }
}
