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
      'players': {
        userId: {
          'cardCount': 0,
          'nickname': nickname,
        },
      },
      'rules': {},
    });
  }

  static Future<void> joinGame(
    String gameId,
    String userId,
    // String nickname,
  ) async {
    final gamePath = 'games/$gameId';
    await FirebaseFirestore.instance.doc(gamePath).set(
      {
        'playerIds': FieldValue.arrayUnion([userId]),
        'players': {
          userId: {
            'cardCount': 0,
            'nickname': 'nickname',
          },
        },
      },
      SetOptions(merge: true),
    );
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
}
