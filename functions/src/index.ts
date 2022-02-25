import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const startGame = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    functions.logger.info("startGame: user not authenticated");
    return;
  }
  const uid = context.auth.uid;
  const gameId: string = data.gameId;

  functions.logger.info("startGame: user authenticated", {uid, gameId});

  const game = await admin.firestore().doc(`games/${gameId}`).get();
  const gameData = game.data();
  const playerIds: string[] = gameData?.playerIds ?? [];
  playerIds.forEach((userId) => {
    admin.firestore().doc(`games/${gameId}/cards/${userId}`).set({cards: []});
  });

  functions.logger.info("startGame: cards distributed", {uid, gameId});
});
