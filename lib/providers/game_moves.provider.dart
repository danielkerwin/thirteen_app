import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_moves.model.dart';
import 'database.provider.dart';

final gameMovesProvider =
    StreamProvider.autoDispose.family<List<GameMoves>, String>(
  (ref, gameId) {
    final database = ref.watch(databaseProvider);
    if (database == null) {
      return const Stream.empty();
    }
    return database.getGameMovesStream(gameId);
  },
  name: 'gameMovesProvider',
);
