import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as helpers from './helpers';
import { cards } from './constants';
import { shuffle } from 'lodash';
import { Card } from './interfaces';

const cardSorter = (a: Card, b: Card) => {
  if (a.value == b.value) {
    return a.suit - b.suit;
  }
  return a.value - b.value;
};

const funcName = 'startGame';

export const startGameFunction = functions
  .region('australia-southeast1')
  .https.onCall(async (data, context) => {
    const uid = context.auth?.uid ?? 'unknown';
    const gameId = data.gameId;
    const gameData = await helpers.getGameData(funcName, gameId, context);

    const playerIds: string[] = gameData?.playerIds ?? [];

    if (playerIds.length % 2 > 0) {
      const message = 'Cannot start game - must be an even number of players';
      functions.logger.info(`${funcName} ${gameId}: ${message}`, {
        uid,
        gameId,
        playerIds,
      });
      throw new functions.https.HttpsError('invalid-argument', message);
    }

    functions.logger.info(
      `${funcName} ${gameId}: there are ${playerIds.length} players`,
      { uid, gameId, playerIds }
    );

    const playerCardsMap = playerIds.reduce((prev, id, idx) => {
      prev.set(idx, []);
      return prev;
    }, new Map<number, Card[]>());

    functions.logger.info(`${funcName} ${gameId}: shuffling cards`, {
      uid,
      gameId,
    });

    const shuffledCards = shuffle(cards);
    if (playerIds.length === 2) {
      shuffledCards.splice(26);
    }

    let playerIndex = 0;
    let lowestCard: Card;
    let activePlayerId: string | null = null;

    shuffledCards.forEach((card) => {
      const player = playerCardsMap.get(playerIndex);
      player?.push(card);
      if (!lowestCard) {
        lowestCard = card;
        activePlayerId = playerIds[playerIndex];
      }

      if (
        card.value < lowestCard.value ||
        (card.value === lowestCard.value && card.suit < lowestCard.suit)
      ) {
        lowestCard = card;
        activePlayerId = playerIds[playerIndex];
      }

      if (card.suit === 0 && card.value === 1) {
        activePlayerId = playerIds[playerIndex];
      }

      const nextPlayer = playerIndex + 1;
      playerIndex = nextPlayer < playerIds.length ? nextPlayer : 0;
    });

    functions.logger.info(`${funcName} ${gameId}: distributing cards`, {
      uid,
      gameId,
    });
    const players = gameData?.players;
    playerIds.forEach((userId, idx) => {
      const cards = playerCardsMap.get(idx) ?? [];
      cards.sort(cardSorter);
      players[userId].cardCount = cards.length;
      admin.firestore().doc(`games/${gameId}/players/${userId}`).set({ cards });
    });

    functions.logger.info(
      `${funcName} ${gameId}: setting game status to active`,
      { uid, gameId }
    );

    await admin
      .firestore()
      .doc(`/games/${gameId}`)
      .set({ players, activePlayerId, status: 1 }, { merge: true });

    return true;
  });
