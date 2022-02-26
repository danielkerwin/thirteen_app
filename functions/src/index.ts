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

      functions.logger.info(
          `startGame ${gameId}: setting game status to active`,
          {uid, gameId}
      );

      admin.firestore()
          .doc(`/games/${gameId}`)
          .set({status: 1}, {merge: true});

      return true;
    });


export const joinGame = functions
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

      admin.firestore()
          .doc(`/games/${gameId}`)
          .set({
            playerIds: [...userData?.playerIds, uid],
            players: {
              [uid]: {cardCount: 0, nickname: userData?.nickname},
            },
          }, {merge: true});

      return true;
    });
