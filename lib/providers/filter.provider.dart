import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/game.constants.dart';

class Filter with ChangeNotifier {
  GameFilters _gameFilter = GameFilters.active;

  set gameFilter(GameFilters filter) {
    _gameFilter = filter;
    notifyListeners();
  }

  GameFilters get gameFilter {
    return _gameFilter;
  }
}

final filterProvider =
    ChangeNotifierProvider.autoDispose<Filter>((ref) => Filter());
