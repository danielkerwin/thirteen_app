import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {getGameData, getNextPlayerId, shouldUpdateRound} from "./constants";
import {GameData, PlayerInfo, Players} from "./interfaces";

const funcName = "skipRound";

export const skipRoundFunction = functions
    .region("australia-southeast1")
    .https
    .onCall(async (data, context) => {
      const uid = context.auth?.uid ?? "unknown";
      const gameId = data.gameId;
      const gameData = await getGameData(funcName, gameId, context);

      if (gameData.activePlayerId !== uid) {
        const message = "Not the active player";
        functions.logger.info(
            `${funcName} ${gameId}: ${message}`,
            {uid, gameId}
        );
        throw new functions.https.HttpsError(
            "invalid-argument",
            message,
        );
      }

      if (gameData.round !== gameData.players[uid].round) {
        const message = "Already skipped this round";
        functions.logger.info(
            `${funcName} ${gameId}: ${message}`,
            {uid, gameId}
        );
        throw new functions.https.HttpsError(
            "invalid-argument",
            message,
        );
      }

      functions.logger.info(
          `${funcName} ${gameId}: skipping round ${gameData.round}`,
          {uid, gameId, round: gameData.round},
      );

      const playerInfo: PlayerInfo = {
        ...gameData?.players[uid],
        round: gameData.round + 1,
      };

      const players: Players = {...gameData.players, [uid]: playerInfo};
      const updatedGame: GameData = {
        ...gameData,
        players,
      };

      const isNextRound = shouldUpdateRound(updatedGame);
      if (isNextRound) {
        updatedGame.round += 1;
        updatedGame.activePlayerId = getNextPlayerId(updatedGame);
      }

      await admin.firestore()
          .doc(`/games/${gameId}`)
          .set(updatedGame);

      return true;
    });
