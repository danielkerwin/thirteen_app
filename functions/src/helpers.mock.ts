import { Card, GameData, GameStatus, PlayerInfo, Players } from './interfaces';
import * as admin from 'firebase-admin';

export class PlayerInfoMock implements PlayerInfo {
  constructor(
    public cardCount: number,
    public nickname: string,
    public round: number,
  ) {}
}

export class GameDataMock implements GameData {
  activePlayerId = 'J679XHaBFsgE7q8hUl1Ybhd9yKh2';
  createdAt = admin.firestore.Timestamp.now();
  createdById = 'XtGDSI5lfrV9zdr7MDXtjUCjRpk1';
  createdByName = 'Dan';
  playerIds = ['J679XHaBFsgE7q8hUl1Ybhd9yKh2', 'XtGDSI5lfrV9zdr7MDXtjUCjRpk1'];
  players: Players = {
    J679XHaBFsgE7q8hUl1Ybhd9yKh2: new PlayerInfoMock(2, 'Dan', 1),
    XtGDSI5lfrV9zdr7MDXtjUCjRpk1: new PlayerInfoMock(4, 'Amy', 1),
  };
  rankIds: string[] = [];
  round = 1;
  rules: Record<string, unknown> = {};
  status: GameStatus = GameStatus.active;
  lowestCardId = '1_0';
  turn = 0;

  constructor(options?: Partial<GameData>) {
    this.activePlayerId = options?.activePlayerId ?? this.activePlayerId;
    this.createdAt = options?.createdAt ?? this.createdAt;
    this.createdByName = options?.createdByName ?? this.createdByName;
    this.playerIds = options?.playerIds ?? this.playerIds;
    this.players = options?.players ?? this.players;
    this.rankIds = options?.rankIds ?? this.rankIds;
    this.round = options?.round ?? this.round;
    this.rules = options?.rules ?? this.rules;
    this.status = options?.status ?? this.status;
    this.lowestCardId = options?.lowestCardId ?? this.lowestCardId;
  }
}

export class CardsMock implements Card {
  constructor(public value: number, public suit: number) {}
}
