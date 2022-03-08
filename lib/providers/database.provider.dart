import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database.service.dart';
import 'auth.provider.dart';

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
