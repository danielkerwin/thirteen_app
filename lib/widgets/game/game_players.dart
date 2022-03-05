import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/game.model.dart';
import 'game_player.dart';

class GamePlayers extends ConsumerWidget {
  final Game game;

  const GamePlayers({
    Key? key,
    required this.game,
  }) : super(key: key);

  List<Widget> buildPlayers(Game game) {
    final List<Widget> gamePlayers = [];

    for (var id in game.playerIds) {
      bool isActive = game.activePlayerId == id;
      final player = game.players[id];
      if (player != null) {
        gamePlayers.add(
          GamePlayer(
            rank: game.rankIds.indexOf(id),
            cardCount: player.cardCount,
            nickname: player.nickname,
            isActive: isActive,
            isMe: game.userId == id,
            isSkipped: player.round > game.round || player.cardCount == 0,
          ),
        );
      }
    }
    return gamePlayers;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('building game_players');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildPlayers(game),
        ),
      ],
    );
  }
}
