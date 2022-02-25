import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.model.dart';

class DatabaseService {
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
      'rules': {},
    });
    final playerPath = '$gamePath/players/$userId';
    await FirebaseFirestore.instance.doc(playerPath).set({
      'cardsCount': 0,
      'nickname': nickname,
    });
    // final cardsPath = '$gamePath/cards/$userId';
    // await FirebaseFirestore.instance.doc(cardsPath).set({
    //   'cards': [],
    // });
  }

  static Future<void> deleteGame(
    String gameId,
  ) async {
    final gamePath = 'games/$gameId';
    await FirebaseFirestore.instance.doc(gamePath).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getGamesStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection('games')
        .where('userIds', arrayContains: userId)
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getGameStream(
    String gameId,
  ) {
    return FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getGamePlayersStream(
    String gameId,
  ) {
    return FirebaseFirestore.instance
        .collection('games/$gameId/players')
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getGamePlayerStream(
    String gameId,
    String userId,
  ) {
    return FirebaseFirestore.instance
        .doc('games/$gameId/players/$userId')
        .snapshots();
  }
}
