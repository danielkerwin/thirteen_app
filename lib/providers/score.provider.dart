import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/score.model.dart';
import 'database.provider.dart';

final scoreProvider = StreamProvider.autoDispose<Score>(
  (ref) {
    final database = ref.watch(databaseProvider);
    if (database == null) {
      return const Stream.empty();
    }
    return database.getScoreStream();
  },
  name: 'scoreProvider',
);
