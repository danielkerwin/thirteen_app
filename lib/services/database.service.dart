import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.model.dart';
import '../models/game_card.model.dart';
import '../models/moves.model.dart';
import '../models/player.model.dart';
import '../models/user_data.model.dart';

typedef DocStream = DocumentSnapshot<Map<String, dynamic>>;
typedef CollectionStream = QuerySnapshot<Map<String, dynamic>>;

class DatabaseService {
  static Future<UserData> getUserFuture(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance.doc('users/$userId').get();
    return UserData.fromFirestore(snapshot);
  }

  static Stream<UserData> getUserStream(String? userId,
      [bool isDarkMode = false]) {
    if (userId == null) {
      return Stream.value(UserData.fromEmpty(isDarkMode));
    }
    return FirebaseFirestore.instance
        .doc('users/$userId')
        .snapshots()
        .map((snapshot) => UserData.fromFirestore(snapshot));
  }

  static Future<void> toggleDarkMode(String userId, bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    return FirebaseFirestore.instance.doc('users/$userId').set(
      {'isDarkMode': isDarkMode},
      SetOptions(merge: true),
    );
  }

  static Future<void> createGame(
    String gameId,
    String userId,
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

  static Future joinGame(String gameId) async {
    final joinGame =
        FirebaseFunctions.instanceFor(region: 'australia-southeast1')
            .httpsCallable('joinGame');
    return joinGame.call({'gameId': gameId});
  }

  static Future startGame(String gameId) async {
    final startGame =
        FirebaseFunctions.instanceFor(region: 'australia-southeast1')
            .httpsCallable('startGame');
    return startGame.call({'gameId': gameId});
  }

  static Future<void> deleteGame(String gameId) async {
    final gamePath = 'games/$gameId';
    return FirebaseFirestore.instance.doc(gamePath).delete();
  }

  static Future playHand(
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

  static Future skipRound(String gameId) async {
    final skipRound =
        FirebaseFunctions.instanceFor(region: 'australia-southeast1')
            .httpsCallable('skipRound');
    return skipRound.call({'gameId': gameId});
  }

  static Stream<List<Game>> getGamesStream(String userId) {
    return FirebaseFirestore.instance
        .collection('games')
        .where('playerIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Game.fromFirestore(doc)).toList();
    });
  }

  static Stream<Game> getGameStream(String gameId) {
    return FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .snapshots()
        .map((snapshot) => Game.fromFirestore(snapshot));
  }

  static Stream<PlayerHand> getPlayerHandStream(String gameId, String userId) {
    return FirebaseFirestore.instance
        .doc('games/$gameId/players/$userId')
        .snapshots()
        .map(
          (snapshot) => PlayerHand.fromFirestore(snapshot),
        );
  }

  static Stream<List<GameMoves>> getMovesStream(String gameId) {
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
