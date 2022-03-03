import {Card, GameData, GameStatus} from "./interfaces";
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const cardSuits = [
  0, // spade
  1, // club
  2, // diamond
  3, // heart
];

// cards from 3 (1) to Ace (13)
const cardValues = Array.from({length: 13}, (k, v) => v + 1);

export const cards: Card[] = cardSuits.flatMap((suit) => {
  return cardValues.map((value) => ({value, suit}));
});

export const getGameData = async (
    funcName: string,
    gameId: string,
    context: functions.https.CallableContext
): Promise<GameData> => {
  if (!context.auth) {
    const message = "User not authenticated";
    functions.logger.info(`${funcName}: ${message}`);
    throw new functions.https.HttpsError(
        "unauthenticated",
        message,
    );
  }
  const uid = context.auth.uid;

  if (!gameId) {
    const message = "Missing Game ID";
    functions.logger.info(`${funcName}: ${message}`, {uid, gameId});
    throw new functions.https.HttpsError(
        "invalid-argument",
        message,
    );
  }

  const game = await admin.firestore().doc(`games/${gameId}`).get();

  if (!game.exists) {
    const message = "Game does not exist";
    functions.logger.info(`${funcName} ${gameId}: ${message}`, {uid, gameId});
    throw new functions.https.HttpsError(
        "not-found",
        message,
    );
  }

  return game.data() as GameData;
};

export const getNextPlayerId = (game: GameData): string => {
  const playerIndex = game.playerIds.indexOf(game.activePlayerId);
  const nextPlayerIdx = playerIndex === game.playerIds.length -1 ?
    0 :
    playerIndex + 1;
  return game.playerIds[nextPlayerIdx];
};

export const updateGame = (
  game: GameData,
  cardsPlayed: number,
  isSkipping: boolean = false
): GameData => {

  // update card count
  const player = game.players[game.activePlayerId];
  player.cardCount -= cardsPlayed;

  // add user to game ranking if they're finished
  if (player.cardCount === 0) {
    game.rankIds.push(game.activePlayerId);
  }

  // skip round if applicable
  if (isSkipping) {
    player.round = game.round + 1;
  }

  // check if game is over
  if (game.rankIds.length === game.playerIds.length - 1) {
    game.status = GameStatus.completed;
  }

  // check if round is over
  if (game.status !== GameStatus.completed) {

    // check for active players
    const playersInRound = game.playerIds.filter((id) => {
      const player = game.players[id];
      return player.round <= game.round || player.cardCount > 0;
    });

    // increment next round
    if (playersInRound.length === 1) {
      game.round += 1;
    }

    // activate next player
    game.activePlayerId = getNextPlayerId(game);

  }
  return game;
};

