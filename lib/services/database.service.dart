import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.model.dart';

typedef DocStream = DocumentSnapshot<Map<String, dynamic>>;
typedef CollectionStream = QuerySnapshot<Map<String, dynamic>>;

class DatabaseService {
  static Stream<DocStream> getUserStream(String userId) {
    return FirebaseFirestore.instance.doc('users/$userId').snapshots();
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

  static Future<void> deleteGame(String gameId) async {
    final gamePath = 'games/$gameId';
    await FirebaseFirestore.instance.doc(gamePath).delete();
  }

  static Stream<CollectionStream> getGamesStream(String userId) {
    return FirebaseFirestore.instance
        .collection('games')
        .where('playerIds', arrayContains: userId)
        .snapshots();
  }

  static Stream<DocStream> getGameStream(String gameId) {
    return FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .snapshots();
  }

  static Stream<CollectionStream> getGamePlayersStream(String gameId) {
    return FirebaseFirestore.instance
        .collection('games/$gameId/players')
        .snapshots();
  }

  static Stream<DocStream> getGamePlayerStream(String gameId, String userId) {
    return FirebaseFirestore.instance
        .doc('games/$gameId/players/$userId')
        .snapshots();
  }
}
