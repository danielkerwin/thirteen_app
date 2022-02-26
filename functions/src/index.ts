import * as admin from "firebase-admin";
import {startGameFunction} from "./startGame";
import {joinGameFunction} from "./joinGame";
import {playHandFunction} from "./playHand";

admin.initializeApp();

export const startGame = startGameFunction;
export const joinGame = joinGameFunction;
export const playHand = playHandFunction;
