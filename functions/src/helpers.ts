import { Card, GameData, GameStatus } from './interfaces';
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { moveErrors } from './constants';

export const getGameData = async (
  funcName: string,
  gameId: string,
  context: functions.https.CallableContext,
): Promise<GameData> => {
  if (!context.auth) {
    const message = 'User not authenticated';
    functions.logger.info(`${funcName}: ${message}`);
    throw new functions.https.HttpsError('unauthenticated', message);
  }
  const uid = context.auth.uid;

  if (!gameId) {
    const message = 'Missing Game ID';
    functions.logger.info(`${funcName}: ${message}`, { uid, gameId });
    throw new functions.https.HttpsError('invalid-argument', message);
  }

  const game = await admin.firestore().doc(`games/${gameId}`).get();

  if (!game.exists) {
    const message = 'Game does not exist';
    functions.logger.info(`${funcName} ${gameId}: ${message}`, { uid, gameId });
    throw new functions.https.HttpsError('not-found', message);
  }

  return game.data() as GameData;
};

export const getNextPlayerId = (
  game: GameData,
  playersInRound: string[],
): string => {
  const activeIndex = playersInRound.indexOf(game.activePlayerId);
  const nextIndex = activeIndex + 1;
  if (nextIndex > playersInRound.length - 1) {
    return playersInRound[0];
  }
  return playersInRound[nextIndex];
};

export const updateGame = (
  game: GameData,
  cardsPlayed: number,
  isSkipping = false,
): GameData => {
  // find next player first
  const playersInRound = game.playerIds.filter((id) => {
    const player = game.players[id];
    return player.round <= game.round && player.cardCount > 0;
  });
  const nextPlayerId = getNextPlayerId(game, playersInRound);
  let playersCount = playersInRound.length;

  // update card count
  const player = game.players[game.activePlayerId];
  player.cardCount -= cardsPlayed;

  // add user to game ranking if they're finished
  if (player.cardCount === 0) {
    game.rankIds.push(game.activePlayerId);
    player.round = game.round + 1;
    playersCount -= 1;
  }

  // skip round if applicable
  if (isSkipping && player.round <= game.round) {
    player.round = game.round + 1;
    playersCount -= 1;
  }

  // check if game is over
  if (game.rankIds.length === game.playerIds.length - 1) {
    game.status = GameStatus.completed;
  }

  // increment turn
  game.turn += 1;

  // check if round is over and activate next player
  if (game.status !== GameStatus.completed) {
    // increment next round
    if (playersCount === 1) {
      game.round += 1;
    }

    // activate next player
    game.activePlayerId = nextPlayerId;
  }
  return game;
};

export const cardSorter = (a: Card, b: Card): number => {
  if (a.value == b.value) {
    return a.suit - b.suit;
  }
  return a.value - b.value;
};

export const isLastCardBetter = (
  currentCards: Card[],
  prevCards: Card[],
): boolean => {
  const current = currentCards[currentCards.length - 1];
  const prev = prevCards[prevCards.length - 1];
  if (current.value === prev.value) {
    return current.suit > prev.suit;
  }
  return current.value > prev.value;
};

export const isSameValue = (cards: Card[]): boolean => {
  const value = cards[0]?.value || 0;
  return cards.every((card) => card.value === value);
};

export const isSequence = (cards: Card[]): boolean => {
  if (cards.length < 3) {
    return false;
  }
  let value = cards[0]?.value - 1 || 0;
  return cards.every((card) => {
    const isSequence = card.value === value + 1;
    value += 1;
    return isSequence;
  });
};

export const getSameValueType = (length: number): string => {
  switch (length) {
    case 1:
      return 'Your single is not better';
    case 2:
      return 'Your doubles are not better';
    case 3:
      return 'Your triples are not better';
    default:
      return 'Your cards are not better';
  }
};

export const isValidMove = (
  game: GameData,
  current: Card[],
  previous: Card[] = [],
): string | null => {
  const cards = current.sort(cardSorter);
  const prev = previous.sort(cardSorter);

  if (game.round === 1 && !prev.length) {
    const hasLowestCard = cards.some((card) => {
      const key = `${card.value}_${card.suit}`;
      return game.lowestCardId === key;
    });
    if (!hasLowestCard) {
      return moveErrors.firstHand;
    }
  }

  if (prev.length && prev.length !== cards.length) {
    return moveErrors.wrongAmount(prev.length);
  }

  if (isSameValue(cards)) {
    if (prev.length && isSequence(prev)) {
      return moveErrors.notRun;
    }
    if (prev.length && !isLastCardBetter(cards, prev)) {
      return moveErrors.sameValueNotBetter(cards.length);
    }
  } else if (isSequence(cards)) {
    if (prev.length && isSameValue(prev)) {
      return moveErrors.notSameValue;
    }
    if (prev.length && !isLastCardBetter(cards, prev)) {
      return moveErrors.runNotBetter;
    }
  } else {
    return moveErrors.notRunNotSame;
  }

  return null;
};
