import * as admin from 'firebase-admin';

export enum GameStatus {
  created,
  active,
  completed,
}

export interface Move {
  round?: number;
  cards: Card[];
}

export interface Card {
  suit: number;
  value: number;
}

export interface PlayerData {
  cards: Card[];
}

export interface PlayerInfo {
  round: number;
  cardCount: number;
  nickname: string;
}

export interface Players {
  [uid: string]: PlayerInfo;
}

export interface GameData {
  activePlayerId: string;
  createdAt: admin.firestore.Timestamp;
  createdById: string;
  createdByName: string;
  playerIds: string[];
  rankIds: string[];
  players: Players;
  rules: Record<string, unknown>;
  status: GameStatus;
  round: number;
  lowestCardId: string;
  turn: number;
}
