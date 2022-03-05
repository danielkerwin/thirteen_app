import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/audio.constant.dart';
import '../../helpers/helpers.dart';
import '../../models/game.model.dart';
import '../../providers/audio.provider.dart';
import '../../providers/database.provider.dart';

class GameManager extends ConsumerStatefulWidget {
  final Game game;

  const GameManager({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  _GameManagerState createState() => _GameManagerState();
}

class _GameManagerState extends ConsumerState<GameManager> {
  bool _isLoading = false;

  Future<void> _joinGame() async {
    setState(() => _isLoading = true);

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    var message = 'You have joined the game!';
    try {
      await ref.read(databaseProvider)!.joinGame(widget.game.id);
      messenger.showSnackBar(Helpers.getSnackBar(message));
    } on FirebaseFunctionsException catch (err) {
      message = err.message ?? 'Failed to join game';
      messenger.showSnackBar(Helpers.getSnackBar(message));
    } catch (err) {
      message = 'Unknown error occurred';
      messenger.showSnackBar(Helpers.getSnackBar(message));
    }

    setState(() => _isLoading = false);
  }

  Future<void> _startGame() async {
    setState(() => _isLoading = true);

    final audio = ref.read(audioProvider);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    var message = 'Game started!';
    try {
      await ref.read(databaseProvider)!.startGame(widget.game.id);
      audio.play(Audio.startGame);
      messenger.showSnackBar(Helpers.getSnackBar(message));
    } on FirebaseFunctionsException catch (err) {
      audio.play(Audio.playCardError);
      message = err.message ?? 'Failed to start game';
      messenger.showSnackBar(Helpers.getSnackBar(message));
    } catch (err) {
      audio.play(Audio.playCardError);
      message = 'Unknown error occurred';
      messenger.showSnackBar(Helpers.getSnackBar(message));
    }

    setState(() => _isLoading = false);
  }

  Future<void> _checkGameStatus(Game game) async {
    if (game.isComplete) {
      final audio = ref.read(audioProvider);
      if (game.isWinner) {
        audio.play(Audio.gameWin);
      } else {
        audio.play(Audio.gameLost);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkGameStatus(widget.game);
  }

  @override
  Widget build(BuildContext context) {
    print('building game_manager');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!widget.game.isJoined && widget.game.isCreated)
            ElevatedButton(
              child: _isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Join Game'),
              onPressed: _isLoading ? null : _joinGame,
            ),
          if (widget.game.isCreatedByMe && widget.game.isCreated)
            Center(
              child: ElevatedButton(
                child: _isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Start game'),
                onPressed: _isLoading ? null : _startGame,
              ),
            ),
          if (widget.game.isComplete)
            Column(
              children: [
                const Text(
                  'Game over',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 5),
                Text(
                  '${widget.game.winningPlayerName} wins',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}
