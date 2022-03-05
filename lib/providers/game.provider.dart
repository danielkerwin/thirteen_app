import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.provider.dart';
import '../models/game.model.dart';

final gamesProvider = StreamProvider.autoDispose<List<Game>>(
  (ref) {
    final database = ref.watch(databaseProvider);
    if (database == null) {
      return const Stream.empty();
    }
    return database.getGamesStream();
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
