import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.provider.dart';
import '../models/user_data.model.dart';

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
