import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/game.model.dart';
import 'game_player.dart';

class GamePlayers extends StatelessWidget {
  final String gameId;
  final String userId;

  const GamePlayers({
    Key? key,
    required this.gameId,
    required this.userId,
  }) : super(key: key);

  List<Widget> buildPlayers(Game game) {
    final List<Widget> gamePlayers = [];

    for (var id in game.playerIds) {
      bool isActive = game.activePlayerId == id;
      final player = game.players[id];
      if (player != null) {
        gamePlayers.add(
          GamePlayer(
            cards: player.cardCount,
            nickname: player.nickname,
            isActive: isActive,
            isMe: userId == id,
          ),
        );
      }
    }
    return gamePlayers;
  }

  @override
  Widget build(BuildContext context) {
    print('building game_players');
    final game = Provider.of<Game>(context);
    final activePlayer =
        game.players[game.activePlayerId]?.nickname ?? 'someone';
    final message =
        game.isActivePlayer ? 'It\'s your turn' : 'It\'s $activePlayer\'s turn';
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildPlayers(game),
        ),
        if (game.isActive) Text(message)
      ],
    );
  }
}
