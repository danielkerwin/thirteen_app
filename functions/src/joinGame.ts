import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as helpers from './helpers';
import { GameStatus, PlayerInfo } from './interfaces';

const funcName = 'playHand';

export const joinGameFunction = functions
  .region('australia-southeast1')
  .https.onCall(async (data, context) => {
    const uid = context.auth?.uid ?? 'unknown';
    const gameId = data.gameId;
    const gameData = await helpers.getGameData(funcName, gameId, context);

    if (gameData.status !== GameStatus.created) {
      const message = 'Game has already started';
      functions.logger.info(`${funcName} ${gameId}: ${message}`, {
        uid,
        gameId,
      });
      throw new functions.https.HttpsError('invalid-argument', message);
    }

    const playerIds: string[] = gameData?.playerIds ?? [];

    functions.logger.info(
      `${funcName} ${gameId}: there are ${playerIds.length} players`,
      { uid, gameId, playerIds },
    );

    if (playerIds.length >= 4) {
      const message = `There is a maximum of 4 players`;
      functions.logger.info(`${funcName} ${gameId}: ${message}`, {
        uid,
        gameId,
        playerIds,
      });
      throw new functions.https.HttpsError('permission-denied', message);
    }

    const user = await admin.firestore().doc(`users/${uid}`).get();

    if (!user.exists) {
      functions.logger.info(`${funcName} ${gameId}: user does not exist`, {
        uid,
        gameId,
      });
      return false;
    }

    functions.logger.info(`${funcName} ${gameId}: joining game`, {
      uid,
      gameId,
    });

    const userData = user.data();

    const playerInfo: PlayerInfo = {
      cardCount: 0,
      nickname: userData?.nickname,
      round: 1,
    };

    await admin
      .firestore()
      .doc(`/games/${gameId}`)
      .set(
        {
          playerIds: [...gameData?.playerIds, uid],
          players: {
            [uid]: playerInfo,
          },
        },
        { merge: true },
      );

    return true;
  });
