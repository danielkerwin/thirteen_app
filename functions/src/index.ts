import * as admin from 'firebase-admin';
import { startGameFunction } from './startGame';
import { joinGameFunction } from './joinGame';
import { playHandFunction } from './playHand';
import { skipRoundFunction } from './skipRound';
import { updateScoresFunction } from './updateScores';

admin.initializeApp();

export const startGame = startGameFunction;
export const joinGame = joinGameFunction;
export const playHand = playHandFunction;
export const skipRound = skipRoundFunction;
export const updateScores = updateScoresFunction;
