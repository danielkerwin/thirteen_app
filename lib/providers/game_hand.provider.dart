import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_hand.model.dart';
import 'database.provider.dart';

final gameHandProvider = StreamProvider.autoDispose.family<GameHand, String>(
  (ref, gameId) {
    final database = ref.watch(databaseProvider);
    if (database == null) {
      return const Stream.empty();
    }
    return database.getGameHandStream(gameId);
  },
  name: 'playerHandProvider',
);
