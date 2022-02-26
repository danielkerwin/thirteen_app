import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/game.model.dart';
import '../services/database.service.dart';
import 'game.screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  Widget _getGameStatus(int statusInt) {
    final status = GameStatus.values[statusInt];
    switch (status) {
      case GameStatus.created:
        return const Text('NEW');
      case GameStatus.active:
        return const Text('ACTIVE');
      case GameStatus.complete:
        return const Text('COMPLETE');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<CollectionStream>(
      stream: DatabaseService.getGamesStream(userId!),
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
            final docs = gamesSnapshot.data?.docs;
            final gameId = docs?[idx].id;
            final gameData = docs?[idx].data();
            final status = gameData?['status'];
            Timestamp timestamp = gameData?['createdAt'];
            DateTime date = timestamp.toDate();

            return Card(
              child: Dismissible(
                key: ValueKey(gameId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  DatabaseService.deleteGame(gameId!);
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
                  trailing: _getGameStatus(status as int),
                  onTap: () => Navigator.of(context).pushNamed(
                    GameScreen.routeName,
                    arguments: gameId,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
