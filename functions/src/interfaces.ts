import * as admin from "firebase-admin";

export interface Card {
  suit: number;
  value: number;
}

export interface PlayerCards {
  cards: Card[];
}

export interface PlayerData {
  cardCount: number;
  nickname: string;
}

export interface GameData {
  activePlayerId: string;
  createdAt: admin.firestore.Timestamp;
  createdById: string;
  createdByName: string;
  playerIds: string[];
  players: {
    [key: string]: PlayerData;
  }
  rules: Record<string, unknown>;
  status: number;
}
