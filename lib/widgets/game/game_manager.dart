import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/audio.constant.dart';
import '../../helpers/helpers.dart';
import '../../models/game.model.dart';
import '../../services/database.service.dart';

class GameManager extends StatefulWidget {
  final String gameId;
  final String userId;

  const GameManager({
    Key? key,
    required this.gameId,
    required this.userId,
  }) : super(key: key);

  @override
  _GameManagerState createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager> {
  bool _isComplete = false;
  bool _isLoading = false;

  Future<void> _joinGame() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    try {
      await DatabaseService.joinGame(widget.gameId);
      messenger.showSnackBar(
        Helpers.getSnackBar('You have joined the game!'),
      );
    } on FirebaseFunctionsException catch (err) {
      messenger.showSnackBar(
        Helpers.getSnackBar(err.message ?? 'Failed to join game'),
      );
    } catch (err) {
      messenger.showSnackBar(
        Helpers.getSnackBar('Unknown error occurred'),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _startGame() async {
    final audio = Provider.of<AudioCache>(context, listen: false);
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    try {
      await DatabaseService.startGame(widget.gameId);
      await audio.play(Audio.startGame);
      messenger.showSnackBar(Helpers.getSnackBar('Game started!'));
    } on FirebaseFunctionsException catch (err) {
      await audio.play(Audio.playCardError);
      messenger.showSnackBar(
        Helpers.getSnackBar(err.message ?? 'Failed to start game'),
      );
    } catch (err) {
      await audio.play(Audio.playCardError);
      messenger.showSnackBar(
        Helpers.getSnackBar('Unknown error occurred'),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _checkGameStatus(Game game) async {
    if (!_isComplete && game.isComplete) {
      _isComplete = true;
      final audio = Provider.of<AudioCache>(context);
      if (game.isWinner) {
        await audio.play(Audio.gameWin);
      } else {
        await audio.play(Audio.gameLost);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('building game_manager');
    final game = Provider.of<Game>(context);

    _checkGameStatus(game);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (game.isJoined && !game.isActive && !game.isCreatedByMe)
          Text('Waiting for ${game.createdByName} to start the game'),
        if (!game.isJoined && game.isCreated)
          ElevatedButton(
            child: _isLoading
                ? const CircularProgressIndicator.adaptive()
                : const Text('Join Game'),
            onPressed: _isLoading ? null : _joinGame,
          ),
        if (game.isCreatedByMe && game.isCreated)
          Center(
            child: ElevatedButton(
              child: _isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Start game'),
              onPressed: _isLoading ? null : _startGame,
            ),
          ),
        if (game.isComplete)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Game over',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 5),
                Text(
                  '${game.winningPlayerName} wins',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}
