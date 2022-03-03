import { GameData, GameStatus } from './interfaces';
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

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
  const activeIndex = game.playerIds.indexOf(game.activePlayerId);
  const nextIndex =
    playersInRound.length < game.playerIds.length
      ? activeIndex
      : activeIndex + 1;
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
  // update card count
  const player = game.players[game.activePlayerId];
  player.cardCount -= cardsPlayed;

  // add user to game ranking if they're finished
  if (player.cardCount === 0) {
    game.rankIds.push(game.activePlayerId);
  }

  // skip round if applicable
  if (isSkipping && player.round <= game.round) {
    player.round = game.round + 1;
  }

  // check if game is over
  if (game.rankIds.length === game.playerIds.length - 1) {
    game.status = GameStatus.completed;
  }

  // check if round is over and activate next player
  if (game.status !== GameStatus.completed) {
    // check for active players
    const playersInRound = game.playerIds.filter((id) => {
      const player = game.players[id];
      return player.round <= game.round && player.cardCount > 0;
    });

    // increment next round
    if (playersInRound.length === 1) {
      game.round += 1;
    }

    // activate next player
    game.activePlayerId = getNextPlayerId(game, playersInRound);
  }
  return game;
};
