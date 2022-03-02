import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {getGameData} from "./constants";
import {PlayerInfo} from "./interfaces";

const funcName = "playHand";

export const joinGameFunction = functions
    .region("australia-southeast1")
    .https
    .onCall(async (data, context) => {
      const uid = context.auth?.uid ?? "unknown";
      const gameId = data.gameId;
      const gameData = await getGameData(funcName, gameId, context);

      const playerIds: string[] = gameData?.playerIds ?? [];

      functions.logger.info(
          `${funcName} ${gameId}: there are ${playerIds.length} players`,
          {uid, gameId, playerIds},
      );

      if (playerIds.length >= 4) {
        const message =
          `${funcName} ${gameId}: there is a maximum of 4 players`;
        functions.logger.info(message, {uid, gameId, playerIds});
        throw new functions.https.HttpsError(
            "permission-denied",
            message,
        );
      }

      const user = await admin.firestore().doc(`users/${uid}`).get();

      if (!user.exists) {
        functions.logger.info(
            `${funcName} ${gameId}: user does not exist`,
            {uid, gameId}
        );
        return false;
      }

      functions.logger.info(
          `${funcName} ${gameId}: joining game`,
          {uid, gameId}
      );

      const userData = user.data();

      const playerInfo: PlayerInfo = {
        cardCount: 0,
        nickname: userData?.nickname,
        round: 1,
      };

      await admin.firestore()
          .doc(`/games/${gameId}`)
          .set({
            playerIds: [...gameData?.playerIds, uid],
            players: {
              [uid]: playerInfo,
            },
          }, {merge: true});

      return true;
    });
