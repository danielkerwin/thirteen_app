import * as helpers from './helpers';
import { CardsMock, GameDataMock, PlayerInfoMock } from './helpers.mock';
import { GameStatus } from './interfaces';

describe('updateGame', () => {
  // beforeEach(() => {});

  it('should add player to ranks (2 players)', () => {
    const players = {
      '1': new PlayerInfoMock(2, 'bill', 2),
      '2': new PlayerInfoMock(6, 'jim', 2),
    };
    const currentPlayerId = '1';
    const playerIds = ['1', '2'];
    const game = new GameDataMock({
      players,
      playerIds,
      activePlayerId: currentPlayerId,
      round: 2,
    });
    expect(game.rankIds.includes(currentPlayerId)).toBe(false);
    const updatedGame = helpers.updateGame(game, 2);
    expect(updatedGame.rankIds.includes(currentPlayerId)).toBe(true);
  });

  it('should increment round (2 players)', () => {
    const players = {
      '1': new PlayerInfoMock(3, 'bill', 2),
      '2': new PlayerInfoMock(6, 'jim', 2),
    };
    const currentPlayerId = '1';
    const nextPlayerId = '2';
    const playerIds = ['1', '2'];
    const game = new GameDataMock({
      players,
      playerIds,
      activePlayerId: currentPlayerId,
      round: 2,
    });
    const updatedGame = helpers.updateGame(game, 0, true);
    expect(updatedGame.players[currentPlayerId].round).toBe(3);
    expect(updatedGame.round).toBe(3);
    expect(updatedGame.activePlayerId).toBe(nextPlayerId);
  });

  it('should increment round with after skipping (4 players)', () => {
    const players = {
      '1': new PlayerInfoMock(3, 'bill', 2),
      '2': new PlayerInfoMock(6, 'jim', 2),
      '3': new PlayerInfoMock(2, 'steve', 1),
      '4': new PlayerInfoMock(9, 'jack', 1),
    };
    const currentPlayerId = '3';
    const nextPlayerId = '4';
    const playerIds = ['1', '2', '3', '4'];
    const game = new GameDataMock({
      players,
      playerIds,
      activePlayerId: currentPlayerId,
      round: 1,
    });
    const updatedGame = helpers.updateGame(game, 0, true);
    expect(updatedGame.players[currentPlayerId].round).toBe(2);
    expect(updatedGame.round).toBe(2);
    expect(updatedGame.activePlayerId).toBe(nextPlayerId);
  });

  it('should not increment round after skipping hand (4 players)', () => {
    const players = {
      '1': new PlayerInfoMock(3, 'bill', 1),
      '2': new PlayerInfoMock(6, 'jim', 1),
      '3': new PlayerInfoMock(2, 'steve', 1),
      '4': new PlayerInfoMock(9, 'jack', 1),
    };
    const currentPlayerId = '1';
    const nextPlayerId = '2';
    const playerIds = ['1', '2', '3', '4'];
    const game = new GameDataMock({
      players,
      playerIds,
      activePlayerId: currentPlayerId,
      round: 1,
    });
    const updatedGame = helpers.updateGame(game, 0, true);
    expect(updatedGame.players[currentPlayerId].round).toBe(2);
    expect(updatedGame.round).toBe(1);
    expect(updatedGame.activePlayerId).toBe(nextPlayerId);
  });

  it('should not increment round after playing hand (2 players)', () => {
    const players = {
      '1': new PlayerInfoMock(3, 'bill', 1),
      '2': new PlayerInfoMock(6, 'jim', 1),
    };
    const currentPlayerId = '1';
    const nextPlayerId = '2';
    const playerIds = ['1', '2'];
    const game = new GameDataMock({
      players,
      playerIds,
      activePlayerId: currentPlayerId,
      round: 1,
    });
    const updatedGame = helpers.updateGame(game, 2);
    expect(updatedGame.players[currentPlayerId].round).toBe(1);
    expect(updatedGame.round).toBe(1);
    expect(updatedGame.activePlayerId).toBe(nextPlayerId);
  });

  it('should skip a skipped player (4 players)', () => {
    const players = {
      '1': new PlayerInfoMock(3, 'bill', 1),
      '2': new PlayerInfoMock(6, 'jim', 1),
      '3': new PlayerInfoMock(2, 'steve', 2),
      '4': new PlayerInfoMock(9, 'jack', 1),
    };
    const currentPlayerId = '2';
    const nextPlayerId = '4';
    const playerIds = ['1', '2', '3', '4'];
    const game = new GameDataMock({
      players,
      playerIds,
      activePlayerId: currentPlayerId,
      round: 1,
    });
    const updatedGame = helpers.updateGame(game, 0, true);
    expect(updatedGame.players[currentPlayerId].round).toBe(2);
    expect(updatedGame.round).toBe(1);
    expect(updatedGame.activePlayerId).toBe(nextPlayerId);
  });

  it('should set game to complete (4 players)', () => {
    const players = {
      '1': new PlayerInfoMock(3, 'bill', 1),
      '2': new PlayerInfoMock(0, 'jim', 1),
      '3': new PlayerInfoMock(2, 'steve', 2),
      '4': new PlayerInfoMock(0, 'jack', 1),
    };
    const currentPlayerId = '1';
    const playerIds = ['1', '2', '3', '4'];
    const rankIds = ['2', '3'];
    const game = new GameDataMock({
      players,
      playerIds,
      rankIds,
      activePlayerId: currentPlayerId,
      round: 1,
    });
    const updatedGame = helpers.updateGame(game, 3);
    expect(updatedGame.players[currentPlayerId].round).toBe(1);
    expect(updatedGame.round).toBe(1);
    expect(updatedGame.status).toBe(GameStatus.completed);
  });

  it('should not skip if already skipped (4 players)', () => {
    const players = {
      '1': new PlayerInfoMock(3, 'bill', 2),
      '2': new PlayerInfoMock(0, 'jim', 1),
      '3': new PlayerInfoMock(2, 'steve', 2),
      '4': new PlayerInfoMock(0, 'jack', 1),
    };
    const currentPlayerId = '1';
    const playerIds = ['1', '2', '3', '4'];
    const game = new GameDataMock({
      players,
      playerIds,
      activePlayerId: currentPlayerId,
      round: 1,
    });
    const updatedGame = helpers.updateGame(game, 0, true);
    expect(updatedGame.players[currentPlayerId].round).toBe(2);
    expect(updatedGame.round).toBe(1);
  });
});

describe('isValidMove', () => {
  it('should be a valid single', () => {
    const message = null;

    expect(helpers.isValidMove([new CardsMock(2, 0)])).toBe(message);
    expect(helpers.isValidMove([new CardsMock(5, 3)])).toBe(message);
    expect(helpers.isValidMove([new CardsMock(8, 2)])).toBe(message);
  });

  it('should be a valid single from previous', () => {
    const a1 = [new CardsMock(2, 1)];
    const b1 = [new CardsMock(2, 0)];

    const a2 = [new CardsMock(5, 3)];
    const b2 = [new CardsMock(4, 3)];

    const a3 = [new CardsMock(8, 2)];
    const b3 = [new CardsMock(8, 1)];

    const message = null;

    expect(helpers.isValidMove(a1, b1)).toBe(message);
    expect(helpers.isValidMove(a2, b2)).toBe(message);
    expect(helpers.isValidMove(a3, b3)).toBe(message);
  });

  it('should be a invalid single from previous', () => {
    const a1 = [new CardsMock(2, 1)];
    const b1 = [new CardsMock(2, 2)];

    const a2 = [new CardsMock(5, 3)];
    const b2 = [new CardsMock(6, 3)];

    const a3 = [new CardsMock(8, 2)];
    const b3 = [new CardsMock(8, 3)];

    const message = 'Cards are not better';

    expect(helpers.isValidMove(a1, b1)).toBe(message);
    expect(helpers.isValidMove(a2, b2)).toBe(message);
    expect(helpers.isValidMove(a3, b3)).toBe(message);
  });

  it('should be a valid double', () => {
    const a1 = [new CardsMock(2, 1), new CardsMock(2, 3)];
    const a2 = [new CardsMock(5, 3), new CardsMock(5, 0)];
    const a3 = [new CardsMock(9, 3), new CardsMock(9, 1)];

    const message = null;

    expect(helpers.isValidMove(a1)).toBe(message);
    expect(helpers.isValidMove(a2)).toBe(message);
    expect(helpers.isValidMove(a3)).toBe(message);
  });

  it('should be a valid double from previous', () => {
    const a1 = [new CardsMock(2, 1), new CardsMock(2, 3)];
    const b1 = [new CardsMock(2, 0), new CardsMock(2, 2)];

    const a2 = [new CardsMock(5, 3), new CardsMock(5, 0)];
    const b2 = [new CardsMock(5, 2), new CardsMock(5, 1)];

    const a3 = [new CardsMock(9, 3), new CardsMock(9, 1)];
    const b3 = [new CardsMock(8, 2), new CardsMock(8, 0)];

    const message = null;

    expect(helpers.isValidMove(a1, b1)).toBe(message);
    expect(helpers.isValidMove(a2, b2)).toBe(message);
    expect(helpers.isValidMove(a3, b3)).toBe(message);
  });

  it('should be a invalid double', () => {
    const a1 = [new CardsMock(2, 1), new CardsMock(3, 3)];
    const a2 = [new CardsMock(5, 3), new CardsMock(6, 0)];
    const a3 = [new CardsMock(8, 3), new CardsMock(4, 1)];

    const message = 'Cards are not same value or in sequence';

    expect(helpers.isValidMove(a1)).toBe(message);
    expect(helpers.isValidMove(a2)).toBe(message);
    expect(helpers.isValidMove(a3)).toBe(message);
  });

  it('should be a invalid double from previous', () => {
    const a1 = [new CardsMock(2, 1), new CardsMock(2, 3)];
    const b1 = [new CardsMock(2, 0), new CardsMock(2, 2)];

    const a2 = [new CardsMock(5, 3), new CardsMock(5, 0)];
    const b2 = [new CardsMock(5, 2), new CardsMock(5, 1)];

    const a3 = [new CardsMock(9, 3), new CardsMock(9, 1)];
    const b3 = [new CardsMock(8, 2), new CardsMock(8, 0)];

    const message = 'Cards are not better';

    expect(helpers.isValidMove(b1, a1)).toBe(message);
    expect(helpers.isValidMove(b2, a2)).toBe(message);
    expect(helpers.isValidMove(b3, a3)).toBe(message);
  });

  it('should be a valid triple', () => {
    const a1 = [new CardsMock(2, 1), new CardsMock(2, 3), new CardsMock(2, 2)];
    const a2 = [new CardsMock(5, 3), new CardsMock(5, 0), new CardsMock(5, 1)];
    const a3 = [new CardsMock(8, 3), new CardsMock(8, 1), new CardsMock(8, 2)];

    const message = null;

    expect(helpers.isValidMove(a1)).toBe(message);
    expect(helpers.isValidMove(a2)).toBe(message);
    expect(helpers.isValidMove(a3)).toBe(message);
  });

  it('should be a invalid triple', () => {
    const a1 = [new CardsMock(3, 1), new CardsMock(2, 3), new CardsMock(2, 2)];
    const a2 = [new CardsMock(5, 3), new CardsMock(4, 0), new CardsMock(5, 1)];
    const a3 = [new CardsMock(8, 3), new CardsMock(1, 1), new CardsMock(8, 2)];

    const message = 'Cards are not same value or in sequence';

    expect(helpers.isValidMove(a1)).toBe(message);
    expect(helpers.isValidMove(a2)).toBe(message);
    expect(helpers.isValidMove(a3)).toBe(message);
  });

  it('should be a valid triple from previous', () => {
    const a1 = [new CardsMock(2, 1), new CardsMock(2, 3), new CardsMock(2, 2)];
    const b1 = [new CardsMock(1, 1), new CardsMock(1, 3), new CardsMock(1, 2)];
    const a2 = [new CardsMock(5, 3), new CardsMock(5, 0), new CardsMock(5, 1)];
    const b2 = [new CardsMock(2, 3), new CardsMock(2, 0), new CardsMock(2, 1)];
    const a3 = [new CardsMock(8, 3), new CardsMock(8, 1), new CardsMock(8, 2)];
    const b3 = [new CardsMock(5, 3), new CardsMock(5, 1), new CardsMock(5, 2)];

    const message = null;

    expect(helpers.isValidMove(a1, b1)).toBe(message);
    expect(helpers.isValidMove(a2, b2)).toBe(message);
    expect(helpers.isValidMove(a3, b3)).toBe(message);
  });

  it('should be a invalid triple from previous', () => {
    const a1 = [new CardsMock(2, 1), new CardsMock(2, 3), new CardsMock(2, 2)];
    const b1 = [new CardsMock(1, 1), new CardsMock(1, 3), new CardsMock(1, 2)];
    const a2 = [new CardsMock(5, 3), new CardsMock(5, 0), new CardsMock(5, 1)];
    const b2 = [new CardsMock(2, 3), new CardsMock(2, 0), new CardsMock(2, 1)];
    const a3 = [new CardsMock(8, 3), new CardsMock(8, 1), new CardsMock(8, 2)];
    const b3 = [new CardsMock(5, 3), new CardsMock(5, 1), new CardsMock(5, 2)];

    const message = 'Cards are not better';

    expect(helpers.isValidMove(b1, a1)).toBe(message);
    expect(helpers.isValidMove(b2, a2)).toBe(message);
    expect(helpers.isValidMove(b3, a3)).toBe(message);
  });
});
