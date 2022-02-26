import 'package:flutter/material.dart';

import '../../services/database.service.dart';

class GameStart extends StatefulWidget {
  final String gameId;

  const GameStart({Key? key, required this.gameId}) : super(key: key);

  @override
  _GameStartState createState() => _GameStartState();
}

class _GameStartState extends State<GameStart> {
  bool _isLoading = false;

  Future<void> _startGame() async {
    setState(() => _isLoading = true);
    await DatabaseService.startGame(widget.gameId);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ElevatedButton(
        child: _isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text('Start game'),
        onPressed: _isLoading ? null : _startGame,
        style: ElevatedButton.styleFrom(
          primary: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
