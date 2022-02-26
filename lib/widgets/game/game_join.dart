import 'package:flutter/material.dart';

import '../../services/database.service.dart';

class GameJoin extends StatefulWidget {
  final String gameId;

  const GameJoin({
    Key? key,
    required this.gameId,
  }) : super(key: key);

  @override
  State<GameJoin> createState() => _GameJoinState();
}

class _GameJoinState extends State<GameJoin> {
  bool _isLoading = false;

  Future<void> _joinGame() async {
    setState(() => _isLoading = true);
    await DatabaseService.joinGame(widget.gameId);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Row(
      mainAxisAlignment: mediaQuery.orientation == Orientation.portrait
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        ElevatedButton(
          child: _isLoading
              ? const CircularProgressIndicator.adaptive()
              : const Text('Join Game'),
          onPressed: _isLoading ? null : _joinGame,
        )
      ],
    );
  }
}
