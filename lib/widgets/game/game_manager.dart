import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../models/game.model.dart';
import '../../services/database.service.dart';
import 'game_error.dart';

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
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    try {
      await DatabaseService.startGame(widget.gameId);
      messenger.showSnackBar(Helpers.getSnackBar('Game started!'));
    } on FirebaseFunctionsException catch (err) {
      messenger.showSnackBar(
        Helpers.getSnackBar(err.message ?? 'Failed to start game'),
      );
    } catch (err) {
      messenger.showSnackBar(
        Helpers.getSnackBar('Unknown error occurred'),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    print('building game_manager');
    final theme = Theme.of(context);
    final game = Provider.of<Game>(context);

    return Column(
      children: [
        if (!game.isJoined)
          ElevatedButton(
            child: _isLoading
                ? const CircularProgressIndicator.adaptive()
                : const Text('Join Game'),
            onPressed: _isLoading ? null : _joinGame,
          ),
        if (game.isCreatedByMe && game.status == GameStatus.created)
          Center(
            child: ElevatedButton(
              child: _isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Start game'),
              // onPressed: _isLoading || widget.isDisabled ? null : _startGame,
              onPressed: _isLoading ? null : _startGame,
              style: ElevatedButton.styleFrom(
                primary: theme.colorScheme.secondary,
              ),
            ),
          )
      ],
    );
  }
}
