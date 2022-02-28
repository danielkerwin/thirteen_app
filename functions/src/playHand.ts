import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Card, GameData, PlayerCards} from "./interfaces";

const isCardBetter = (prev: Card, current: Card) => {
  if (current.value === prev.value) {
    return current.suit > prev.suit;
  }
  return current.value > prev.value;
};


export const playHandFunction = functions
    .region("australia-southeast1")
    .https
    .onCall(async (data, context) => {
      if (!context.auth) {
        functions.logger.info("playHand: user not authenticated");
        return false;
      }
      const uid = context.auth.uid;
      const gameId: string = data.gameId;

      if (!gameId) {
        functions.logger.info("playHand: missing gameId", {uid, gameId});
        return false;
      }

      const gameRef = await admin.firestore()
          .doc(`games/${gameId}`).get();
      const gameData = gameRef.data() as GameData;

      console.log(gameData.activePlayerId, uid)
      console.log(gameData.activePlayerId !== uid)
      if (!gameData || gameData.activePlayerId !== uid) {
        const message = "Not the active player - please wait your turn";
        functions.logger.info(
            `playHand: ${message}`,
            {uid, gameId}
        );
        throw new functions.https.HttpsError(
          "invalid-argument",
          message,
      );        
      }

      const currentMove: Card[] = data.cards;
      functions.logger.info(
          "playHand: got cards to play",
          {uid, gameId, currentMove}
      );

      currentMove.sort((a, b) => {
        return a.value - b.value || a.suit - b.suit;
      });

      const moves = await admin.firestore().collection(
          `games/${gameId}/moves`
      ).orderBy("createdAt", "desc").limit(1).get();

      // TODO: TEMP ALLOW ALL MOVES
      if (gameId) {
        // add move to stack
        const movePromise = admin.firestore()
            .collection(`games/${gameId}/moves`)
            .doc()
            .set({
              createdAt: admin.firestore.Timestamp.now(),
              cards: currentMove,
            });

        // update next player
        const playerIndex = gameData.playerIds.indexOf(uid);
        const nextPlayerIdx = playerIndex === gameData.playerIds.length -1 ?
          0 :
          playerIndex + 1;
        const nextPlayerId = gameData.playerIds[nextPlayerIdx];
        const player = gameData.players[uid];
        player.cardCount -= currentMove.length;
        const gamePromise = admin.firestore().doc(`games/${gameId}`).set(
            {activePlayerId: nextPlayerId, players: {[uid]: player}},
            {merge: true},
        );

        // remove cards from hand
        const playerRef = await admin.firestore()
            .doc(`games/${gameId}/players/${uid}`).get();
        const playerDoc = playerRef.data() as PlayerCards;
        const cardsToRemove = currentMove.reduce((prev, card) => {
          prev.set(`${card.suit}_${card.value}`, true);
          return prev;
        }, new Map<string, boolean>());
        const updatedCards = playerDoc.cards.filter((card) => {
          return !cardsToRemove.has(`${card.suit}_${card.value}`);
        });
        playerDoc.cards = updatedCards;
        const playerPromise = admin.firestore()
            .doc(`games/${gameId}/players/${uid}`)
            .update(playerDoc);

        // execute all promises
        await Promise.all([movePromise, gamePromise, playerPromise]);
        return true;
      }

      const previousMove = moves.empty ? [] : moves.docs[0].data() as Card[];
      functions.logger.info(
          "playHand: evaluating move",
          {uid, gameId, currentMove, previousMove}
      );

      // if no other moves, move must include 3 of spades
      if (moves.empty &&
      (currentMove[0].suit !== 0 || currentMove[0].value !== 1)
      ) {
        functions.logger.info(
            "playHand: first move must play 3 of spades",
            {uid, gameId, currentMove},
        );
        return false;
      }

      // if there are other moves, move must have same amount of cards
      // except for bombs (exception)
      if (!moves.empty && (currentMove.length !== previousMove.length)) {
        functions.logger.info("playHand: wrong amount of cards", {uid, gameId});
        return false;
      }

      // singles
      if (currentMove.length === 1) {
        functions.logger.info("playHand: playing singles", {uid, gameId});
        if (!moves.empty) {
          return isCardBetter(previousMove[0], currentMove[0]);
        }
        return true;
      }

      // doubles
      if (currentMove.length === 2) {
        const isDouble = currentMove[0].value ===
        currentMove[1].value;
        functions.logger.info(
            "playHand: playing doubles",
            {uid, gameId, isDouble}
        );

        if (!moves.empty) {
          return isDouble && isCardBetter(previousMove[1], currentMove[1]);
        }
        return isDouble;
      }

      // triple or run
      if (currentMove.length > 2) {
        const a = currentMove[0].value;
        const b = currentMove[1].value;
        const c = currentMove[2].value;

        const isTriple = a === b && b === c;
        const isRun = a < b && b < c;
        const isRunOrTriple = isTriple || isRun;

        functions.logger.info(
            "playHand: playing triple or run",
            {uid, gameId, isTriple, isRun}
        );

        if (!moves.empty) {
          return isRunOrTriple && isCardBetter(previousMove[2], currentMove[2]);
        }
        return isRunOrTriple;
      }

      // await admin.firestore()
      // .doc(`/games/${gameId}`)
      // .set({players, activePlayerId, status: 1}, {merge: true});


      return true;
    });
