import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { GameData, GameScores, GameStatus } from './interfaces';

export const updateScoresFunction = functions
  .region('australia-southeast1')
  .firestore.document('/games/{gameId}')
  .onUpdate(async (data) => {
    const gameDataBefore = data.before.data() as GameData;
    const gameDataAfter = data.after.data() as GameData;
    const wasActive = gameDataBefore.status === GameStatus.active;
    const isComplete = gameDataAfter.status === GameStatus.completed;
    if (wasActive && isComplete) {
      const promises = gameDataAfter.playerIds.map((id) => {
        const rankIndex = gameDataAfter.rankIds.indexOf(id);
        const rank =
          rankIndex > -1 ? rankIndex + 1 : gameDataAfter.playerIds.length;
        const update: GameScores = {
          gamesPlayed: admin.firestore.FieldValue.increment(1),
          ranks: {
            [gameDataAfter.playerIds.length]: {
              [rank]: admin.firestore.FieldValue.increment(1),
            },
          },
        };
        if (rankIndex === 0) {
          update.gamesWon = admin.firestore.FieldValue.increment(1);
        }
        return admin
          .firestore()
          .collection('scores')
          .doc(id)
          .set(update, { merge: true });
      });
      await Promise.all(promises);
    }
  });
