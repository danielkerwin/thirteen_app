import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {cards} from "./constants";
import {shuffle} from "lodash";
import {Card} from "./interfaces";

admin.initializeApp();


export const startGame = functions
    .region("australia-southeast1")
    .https
    .onCall(async (data, context) => {
      if (!context.auth) {
        functions.logger.info("startGame: user not authenticated");
        return false;
      }
      const uid = context.auth.uid;
      const gameId: string = data.gameId;

      if (!gameId) {
        functions.logger.info("startGame: missing gameId", {uid, gameId});
        return false;
      }

      const game = await admin.firestore().doc(`games/${gameId}`).get();
      const gameData = game.data();
      const playerIds: string[] = gameData?.playerIds ?? [];

      functions.logger.info(
          `startGame ${gameId}: there are ${playerIds.length} players`,
          {uid, gameId, playerIds},
      );

      if (playerIds.length % 2 !== 0) {
        functions.logger.info(
            `startGame ${gameId}: there must be an even number of players`,
            {uid, gameId, playerIds},
        );
        return false;
      }

      const playerCardsMap = playerIds.reduce((prev, id, idx) => {
        prev.set(idx, []);
        return prev;
      }, new Map<number, Card[]>());

      functions.logger.info(
          `startGame ${gameId}: shuffling cards`,
          {uid, gameId}
      );
      const shuffledCards = shuffle(cards);

      let playerIndex = 0;
      shuffledCards.forEach((card) => {
        const player = playerCardsMap.get(playerIndex);
    player?.push(card);
    const nextPlayer = playerIndex + 1;
    playerIndex = nextPlayer < playerIds.length ? nextPlayer : 0;
      });

      functions.logger.info(
          `startGame ${gameId}: distributing cards`,
          {uid, gameId}
      );
      playerIds.forEach((userId, idx) => {
        admin.firestore().doc(
            `games/${gameId}/players/${userId}`
        ).set({cards: playerCardsMap.get(idx)});
      });
      return true;
    });
