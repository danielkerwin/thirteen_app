import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const deleteGameFunction = functions
  .region('australia-southeast1')
  .firestore.document('/games/{gameId}')
  .onDelete(async (game) => {
    const gameId = game.id;

    const movesDelete = await admin
      .firestore()
      .collection('games')
      .doc(gameId)
      .collection('moves')
      .get();

    const playersDelete = await admin
      .firestore()
      .collection('games')
      .doc(gameId)
      .collection('players')
      .get();

    const batch = admin.firestore().batch();

    if (movesDelete.size > 0) {
      movesDelete.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });
    }

    if (playersDelete.size > 0) {
      playersDelete.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });
    }

    if (movesDelete.size > 0 || playersDelete.size > 0) {
      await batch.commit();
    }
  });
