import * as helpers from './helpers';
import { GameDataMock, PlayerInfoMock } from './helpers.mock';
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
