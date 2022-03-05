import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.model.dart';
import '../models/game_moves.model.dart';
import '../models/game_hand.model.dart';
import '../models/user_data.model.dart';
import '../services/database.service.dart';
import 'database.provider.dart';

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
