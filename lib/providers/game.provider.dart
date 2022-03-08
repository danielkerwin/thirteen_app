import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/game.constants.dart';
import 'database.provider.dart';
import '../models/game.model.dart';
import 'filter.provider.dart';

final gamesProvider = StreamProvider.autoDispose<List<Game>>(
  (ref) {
    final database = ref.watch(databaseProvider);
    final gameFilter = ref.watch(filterProvider);
    if (database == null) {
      return const Stream.empty();
    }
    final status = gameFilter.gameFilter.index == GameFilters.active.index
        ? [GameStatus.created.index, GameStatus.active.index]
        : [GameStatus.complete.index];
    return database.getGamesStream(status);
  },
  name: 'gamesProvider',
);

final gameProvider = StreamProvider.autoDispose.family<Game, String>(
  (ref, gameId) {
    final database = ref.watch(databaseProvider);
    if (database == null) {
      return const Stream.empty();
    }
    return database.getGameStream(gameId);
  },
  name: 'gameProvider',
);
