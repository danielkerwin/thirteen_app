import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/game.constants.dart';
import '../models/game.model.dart';
import '../models/game_card.model.dart';
import '../models/game_moves.model.dart';
import '../models/game_hand.model.dart';
import '../models/score.model.dart';
import '../models/user_data.model.dart';

typedef DocSnapshot = DocumentSnapshot<Map<String, dynamic>>;
typedef ColSnapshot = QuerySnapshot<Map<String, dynamic>>;

class DatabaseService with ChangeNotifier {
  final String userId;
  GameFilters? _gameFilters = GameFilters.active;

  DatabaseService({
    required this.userId,
  });

  set gameFilters(GameFilters? filter) {
    _gameFilters = filter;
    notifyListeners();
  }

  GameFilters? get gameFilters {
    return _gameFilters;
  }

  Future<UserData> getUserFuture() async {
    final snapshot =
        await FirebaseFirestore.instance.doc('users/$userId').get();
    return UserData.fromFirestore(snapshot);
  }

  Stream<UserData> getUserStream() {
    return FirebaseFirestore.instance
        .doc('users/$userId')
        .snapshots()
        .map((snapshot) => UserData.fromFirestore(snapshot));
  }

  Future<void> toggleDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    return FirebaseFirestore.instance.doc('users/$userId').set(
      {'isDarkMode': isDarkMode},
      SetOptions(merge: true),
    );
  }

  Future<void> createGame(
    String gameId,
    String nickname,
  ) async {
    final gamePath = 'games/$gameId';
    await FirebaseFirestore.instance.doc(gamePath).set({
      'createdAt': Timestamp.now(),
      'createdById': userId,
      'createdByName': nickname,
      'status': GameStatus.created.index,
      'playerIds': [userId],
      'players': {
        userId: {
          'cardCount': 0,
          'nickname': nickname,
          'round': 1,
        },
      },
      'rules': {},
      'rankIds': [],
      'round': 1,
      'turn': 1,
    });
  }

  Future joinGame(String gameId) async {
    final joinGame =
        FirebaseFunctions.instanceFor(region: 'australia-southeast1')
            .httpsCallable('joinGame');
    return joinGame.call({'gameId': gameId});
  }

  Future startGame(String gameId) async {
    final startGame =
        FirebaseFunctions.instanceFor(region: 'australia-southeast1')
            .httpsCallable('startGame');
    return startGame.call({'gameId': gameId});
  }

  Future<void> deleteGame(String gameId) async {
    final gamePath = 'games/$gameId';
    return FirebaseFirestore.instance.doc(gamePath).delete();
  }

  Future playHand(
    String gameId,
    List<GameCard> selected,
  ) async {
    final playHand =
        FirebaseFunctions.instanceFor(region: 'australia-southeast1')
            .httpsCallable('playHand');

    return playHand.call({
      'gameId': gameId,
      'cards': selected
          .map(
            (card) => {
              'value': card.value,
              'suit': card.suit.index,
            },
          )
          .toList(),
    });
  }

  Future skipRound(String gameId) async {
    final skipRound =
        FirebaseFunctions.instanceFor(region: 'australia-southeast1')
            .httpsCallable('skipRound');
    return skipRound.call({'gameId': gameId});
  }

  Stream<List<Game>> getGamesStream() {
    final status = _gameFilters!.index == GameFilters.active.index
        ? [GameStatus.created.index, GameStatus.active.index]
        : [GameStatus.complete.index];
    return FirebaseFirestore.instance
        .collection('games')
        .where('playerIds', arrayContains: userId)
        .where('status', whereIn: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Game.fromFirestore(doc, userId))
          .toList();
    });
  }

  Stream<Score> getScoreStream() {
    return FirebaseFirestore.instance
        .collection('scores')
        .doc(userId)
        .snapshots()
        .map((snapshot) => Score.fromFirestore(snapshot));
  }

  Stream<Game> getGameStream(String gameId) {
    return FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .snapshots()
        .map((snapshot) => Game.fromFirestore(snapshot, userId));
  }

  Stream<GameHand> getGameHandStream(String gameId) {
    return FirebaseFirestore.instance
        .doc('games/$gameId/players/$userId')
        .snapshots()
        .map(
          (snapshot) => GameHand.fromFirestore(snapshot),
        );
  }

  Stream<List<GameMoves>> getGameMovesStream(String gameId) {
    return FirebaseFirestore.instance
        .collection('games/$gameId/moves')
        .orderBy('createdAt', descending: true)
        .limit(2)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => GameMoves.fromFirestore(doc)).toList(),
        );
  }
}
