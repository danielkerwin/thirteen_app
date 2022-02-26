import * as admin from "firebase-admin";
import { startGameFunction } from "./startGame";
import { joinGameFunction } from "./joinGame";

admin.initializeApp();

export const startGame = startGameFunction;
export const joinGame = joinGameFunction;