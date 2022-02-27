import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    await DatabaseService.joinGame(widget.gameId);
    setState(() => _isLoading = false);
  }

  Future<void> _startGame() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await DatabaseService.startGame(widget.gameId);
      messenger.showSnackBar(const SnackBar(content: Text('Game started!')));
    } on FirebaseFunctionsException catch (err) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(err.message ?? 'Failed to start game'),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    print('building game_manager');
    final theme = Theme.of(context);

    return StreamBuilder<DocStream>(
        stream: DatabaseService.getGameStream(widget.gameId),
        builder: (context, gameSnapshot) {
          if (gameSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (gameSnapshot.hasError) {
            return GameError(gameId: widget.gameId);
          }
          if (!gameSnapshot.data!.exists) {
            return GameError(gameId: widget.gameId);
          }
          final gameData = gameSnapshot.data!.data()!;
          final status = gameData['status'];
          final myData = gameData['players'][widget.userId];

          final isCreatedByMe = gameData['createdById'] == widget.userId;

          return Column(
            children: [
              if (myData == null)
                ElevatedButton(
                  child: _isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text('Join Game'),
                  onPressed: _isLoading ? null : _joinGame,
                ),
              if (isCreatedByMe && status == 0)
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
        });
  }
}
