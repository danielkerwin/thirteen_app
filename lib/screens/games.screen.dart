import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/database.service.dart';
import 'game.screen.dart';

class GamesScreen extends StatelessWidget {
  static const routeName = '/games';
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: DatabaseService.getGamesStream(),
        builder: (context, gamesSnapshot) {
          if (gamesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return ListView.builder(
            itemCount: gamesSnapshot.data?.docs.length ?? 0,
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            itemBuilder: (ctx, idx) {
              final gameId = gamesSnapshot.data?.docs[idx].id;
              final gameData = gamesSnapshot.data?.docs[idx].data();
              Timestamp timestamp = gameData?['createdAt'];
              DateTime date = timestamp.toDate();

              return Card(
                child: Dismissible(
                  key: ValueKey(gameId),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    DatabaseService.deleteGame(gameId as String);
                  },
                  background: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(right: 16.0),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text('Game #$gameId'),
                    subtitle: Text(DateFormat.yMMMd().format(date)),
                    onTap: () => Navigator.of(context).pushNamed(
                      GameScreen.routeName,
                      arguments: gameId,
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
