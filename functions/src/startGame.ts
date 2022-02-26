import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {cards} from "./constants";
import {shuffle} from "lodash";
import {Card} from "./interfaces";

export const startGameFunction = functions
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

      if (!game.exists) {
        functions.logger.info("startGame: game does not exist", {uid, gameId});
        return false;
      }

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
      let activePlayerId;
      shuffledCards.forEach((card) => {
        const player = playerCardsMap.get(playerIndex);
        player?.push(card);

        if (card.suit === 0 && card.value === 1) {
          activePlayerId = playerIds[playerIndex];
        }

        const nextPlayer = playerIndex + 1;
        playerIndex = nextPlayer < playerIds.length ? nextPlayer : 0;
      });

      functions.logger.info(
          `startGame ${gameId}: distributing cards`,
          {uid, gameId}
      );
      const players = gameData?.players;
      playerIds.forEach((userId, idx) => {
        const cards = playerCardsMap.get(idx);
        players[userId].cardCount = cards?.length;
        admin.firestore().doc(
            `games/${gameId}/players/${userId}`
        ).set({cards});
      });

      functions.logger.info(
          `startGame ${gameId}: setting game status to active`,
          {uid, gameId}
      );

      await admin.firestore()
          .doc(`/games/${gameId}`)
          .set({players, activePlayerId, status: 1}, {merge: true});

      return true;
    });
