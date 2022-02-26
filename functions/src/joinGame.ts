import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const joinGameFunction = functions
    .region("australia-southeast1")
    .https
    .onCall(async (data, context) => {
      if (!context.auth) {
        functions.logger.info("joinGame: user not authenticated");
        return false;
      }
      const uid = context.auth.uid;
      const gameId: string = data.gameId;

      if (!gameId) {
        functions.logger.info("joinGame: missing gameId", {uid, gameId});
        return false;
      }

      const game = await admin.firestore().doc(`games/${gameId}`).get();

      if (!game.exists) {
        functions.logger.info("joinGame: game does not exist", {uid, gameId});
        return false;
      }

      const gameData = game.data();
      const playerIds: string[] = gameData?.playerIds ?? [];

      functions.logger.info(
          `joinGame ${gameId}: there are ${playerIds.length} players`,
          {uid, gameId, playerIds},
      );

      if (playerIds.length >= 4) {
        functions.logger.info(
            `joinGame ${gameId}: there is a maximum of 4 players`,
            {uid, gameId, playerIds},
        );
        return false;
      }

      const user = await admin.firestore().doc(`users/${uid}`).get();

      if (!user.exists) {
        functions.logger.info(
            `joinGame ${gameId}: user does not exist`,
            {uid, gameId}
        );
        return false;
      }


      functions.logger.info(
          `joinGame ${gameId}: joining game`,
          {uid, gameId}
      );

      const userData = user.data();

      await admin.firestore()
          .doc(`/games/${gameId}`)
          .set({
            playerIds: [...gameData?.playerIds, uid],
            players: {
              [uid]: {cardCount: 0, nickname: userData?.nickname},
            },
          }, {merge: true});

      return true;
    });
