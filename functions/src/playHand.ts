import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { Card, Move, PlayerData } from './interfaces';
import * as helpers from './helpers';

const funcName = 'playHand';

export const playHandFunction = functions
  .region('australia-southeast1')
  .https.onCall(async (data, context) => {
    const uid = context.auth?.uid ?? 'unknown';
    const gameId = data.gameId;
    const gameData = await helpers.getGameData(funcName, gameId, context);

    if (!gameData || gameData.activePlayerId !== uid) {
      const message = 'Not the active player';
      functions.logger.info(`${funcName} ${gameId}: ${message}`, {
        uid,
        gameId,
      });
      throw new functions.https.HttpsError('invalid-argument', message);
    }

    const currentCards: Card[] = data.cards;
    functions.logger.info(`${funcName} ${gameId}: got cards to play`, {
      uid,
      gameId,
      currentCards,
    });

    const moves = await admin
      .firestore()
      .collection(`games/${gameId}/moves`)
      .orderBy('createdAt', 'desc')
      .limit(1)
      .get();

    const previousMove = moves.empty
      ? []
      : (moves.docs.map((move) => move.data()) as Move[]);
    const roundMoves = previousMove.filter(
      (move) => move.round === gameData.round,
    );
    const previousCards = roundMoves.length ? roundMoves[0].cards : [];

    functions.logger.info(`${funcName} ${gameId}: evaluating move`, {
      uid,
      gameId,
      currentCards,
      previousCards,
    });

    const error = helpers.isValidMove(gameData, currentCards, previousCards);

    if (error) {
      const message = `${funcName} ${gameId}: ${error}`;
      functions.logger.info(message, {
        uid,
        gameId,
        error,
        currentCards,
        previousCards,
      });
      throw new functions.https.HttpsError('invalid-argument', error);
    }

    // add move to stack
    const movePromise = admin
      .firestore()
      .collection(`games/${gameId}/moves`)
      .doc()
      .set({
        createdAt: admin.firestore.Timestamp.now(),
        cards: currentCards,
        round: gameData.round,
        userId: uid,
      });

    // update game
    const updatedGameData = helpers.updateGame(gameData, currentCards.length);
    const updateGamePromise = admin
      .firestore()
      .doc(`games/${gameId}`)
      .set(updatedGameData);

    // remove cards from hand
    const playerRef = await admin
      .firestore()
      .doc(`games/${gameId}/players/${uid}`)
      .get();
    const playerDoc = playerRef.data() as PlayerData;
    const cardsToRemove = currentCards.reduce((prev, card) => {
      prev.set(`${card.suit}_${card.value}`, true);
      return prev;
    }, new Map<string, boolean>());
    const updatedCards = playerDoc.cards.filter((card) => {
      return !cardsToRemove.has(`${card.suit}_${card.value}`);
    });
    playerDoc.cards = updatedCards;
    const playerPromise = admin
      .firestore()
      .doc(`games/${gameId}/players/${uid}`)
      .update(playerDoc);

    // execute all promises
    await Promise.all([movePromise, updateGamePromise, playerPromise]);

    return true;
  });
