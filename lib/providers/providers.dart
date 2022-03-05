import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.model.dart';
import '../models/moves.model.dart';
import '../models/player.model.dart';
import '../models/user_data.model.dart';
import '../services/database.service.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print(
      '''{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''',
    );
  }
}

final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) {
    throw UnimplementedError();
  },
  name: 'sharedPrefsProvider',
);

final audioProvider = Provider<AudioCache>(
  (ref) {
    return AudioCache(
      prefix: 'assets/audio/',
      respectSilence: true,
    );
  },
  name: 'audioProvider',
);

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
  name: 'firebaseAuthProvider',
);

final authStateChangesProvider = StreamProvider.autoDispose(
  (ref) {
    return ref.watch(firebaseAuthProvider).authStateChanges();
  },
  name: 'authStateChangesProvider',
);

final databaseProvider = Provider.autoDispose<DatabaseService?>(
  (ref) {
    final auth = ref.watch(authStateChangesProvider);
    if (auth.value?.uid != null) {
      return DatabaseService(userId: auth.value!.uid);
    }
    return null;
  },
  name: 'databaseProvider',
);

final userDataProvider = StreamProvider.autoDispose<UserData>(
  (ref) {
    final database = ref.watch(databaseProvider);
    if (database == null) {
      return const Stream.empty();
    }
    return database.getUserStream();
  },
  name: 'userDataProvider',
);

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

final gameMovesProvider =
    StreamProvider.autoDispose.family<List<GameMoves>, String>(
  (ref, gameId) {
    final database = ref.watch(databaseProvider);
    if (database == null) {
      return const Stream.empty();
    }
    return database.getMovesStream(gameId);
  },
  name: 'gameMovesProvider',
);

final playerHandProvider =
    StreamProvider.autoDispose.family<PlayerHand, String>(
  (ref, gameId) {
    final database = ref.watch(databaseProvider);
    if (database == null) {
      return const Stream.empty();
    }
    return database.getPlayerHandStream(gameId);
  },
  name: 'playerHandProvider',
);
