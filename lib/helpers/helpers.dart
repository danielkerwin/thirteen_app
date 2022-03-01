import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game.model.dart';
import '../models/moves.model.dart';
import '../models/player.model.dart';
import '../screens/game.screen.dart';
import '../services/database.service.dart';

class Helpers {
  static SnackBar getSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(fontFamily: 'Roboto'),
      ),
    );
  }

  static buildGameScreenRoute(
    String gameId,
    String userId,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (ctx) {
        return MultiProvider(
          providers: [
            StreamProvider<Game>.value(
              value: DatabaseService.getGameStream(gameId),
              initialData: Game.fromEmpty(),
            ),
            StreamProvider<List<GameMoves>>.value(
              value: DatabaseService.getMovesStream(gameId),
              initialData: const [],
            ),
            StreamProvider<PlayerHand>.value(
              value: DatabaseService.getPlayerHandStream(
                gameId,
                userId,
              ),
              initialData: PlayerHand.fromEmpty(),
            )
          ],
          child: GameScreen(gameId: gameId),
        );
      },
      settings: settings,
    );
  }
}
