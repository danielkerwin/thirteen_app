import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database.service.dart';
import 'game_user.dart';

class GamePlayers extends StatelessWidget {
  final String gameId;
  final String userId;

  const GamePlayers({
    Key? key,
    required this.gameId,
    required this.userId,
  }) : super(key: key);

  List<GameUser> buildPlayers(QuerySnapshot<Map<String, dynamic>> data) {
    final List<GameUser> gameUsers = [];
    for (var doc in data.docs) {
      if (doc.id != userId) {
        gameUsers.add(
          GameUser(
            cards: doc['cardsCount'],
            nickname: doc['nickname'],
          ),
        );
      }
    }
    return gameUsers;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseService.getGamePlayersStream(gameId),
      builder: (context, gamePlayersSnapshot) {
        if (gamePlayersSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        // if (gamePlayersSnapshot.data!.size == 1) {
        //   return const Center(
        //     child: Text('Waiting for players...'),
        //   );
        // }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildPlayers(gamePlayersSnapshot.data!),
        );
      },
    );
  }
}
