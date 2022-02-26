import 'package:flutter/material.dart';

import '../../services/database.service.dart';
import 'game_user.dart';

class GameJoin extends StatelessWidget {
  final String gameId;
  final Map<String, dynamic>? myData;

  const GameJoin({
    Key? key,
    this.myData,
    required this.gameId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Row(
      mainAxisAlignment: mediaQuery.orientation == Orientation.portrait
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (myData == null)
          ElevatedButton(
            child: const Text('Join Game'),
            onPressed: () => DatabaseService.joinGame(gameId),
          )
        else
          GameUser(
            nickname: 'Me',
            cards: myData?['cardCount'],
          ),
      ],
    );
  }
}
