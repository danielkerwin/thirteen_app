import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static Future<void> createGame(
    String gameId,
    String userId,
    String userName,
  ) async {
    final gamePath = 'games/$gameId';
    await FirebaseFirestore.instance.doc(gamePath).set({
      'createdAt': Timestamp.now(),
      'createdById': userId,
      'createdByName': userName,
      'rules': {},
    });
    final playerPath = '$gamePath/players/$userId';
    await FirebaseFirestore.instance.doc(playerPath).set({'cards': []});
  }

  static Future<void> deleteGame(
    String gameId,
  ) async {
    final gamePath = 'games/$gameId';
    await FirebaseFirestore.instance.doc(gamePath).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getGamesStream() {
    return FirebaseFirestore.instance.collection('games').snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getGameStream(
    String gameId,
  ) {
    return FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .snapshots();
  }
}
