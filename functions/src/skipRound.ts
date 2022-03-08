import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as helpers from './helpers';
import { GameStatus } from './interfaces';

const funcName = 'skipRound';

export const skipRoundFunction = functions
  .region('australia-southeast1')
  .https.onCall(async (data, context) => {
    const uid = context.auth?.uid ?? 'unknown';
    const gameId = data.gameId;
    const gameData = await helpers.getGameData(funcName, gameId, context);

    if (gameData.status !== GameStatus.active) {
      const message = 'Game is not active';
      functions.logger.info(`${funcName} ${gameId}: ${message}`, {
        uid,
        gameId,
      });
      throw new functions.https.HttpsError('invalid-argument', message);
    }

    if (gameData.activePlayerId !== uid) {
      const message = 'Not the active player';
      functions.logger.info(`${funcName} ${gameId}: ${message}`, {
        uid,
        gameId,
      });
      throw new functions.https.HttpsError('invalid-argument', message);
    }

    if (gameData.round === 1 && gameData.turn === 1) {
      const message = 'Cannot skip the first hand';
      functions.logger.info(`${funcName} ${gameId}: ${message}`, {
        uid,
        gameId,
      });
      throw new functions.https.HttpsError('invalid-argument', message);
    }

    if (gameData.players[uid].round > gameData.round) {
      const message = 'Already skipped this round';
      functions.logger.info(`${funcName} ${gameId}: ${message}`, {
        uid,
        gameId,
      });
      throw new functions.https.HttpsError('invalid-argument', message);
    }

    functions.logger.info(
      `${funcName} ${gameId}: skipping round ${gameData.round}`,
      { uid, gameId, round: gameData.round },
    );

    const updatedGameData = helpers.updateGame(gameData, 0, true);

    await admin.firestore().doc(`/games/${gameId}`).set(updatedGameData);

    return true;
  });
