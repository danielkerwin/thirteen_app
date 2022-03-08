import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/game.constants.dart';
import '../../providers/database.provider.dart';

class GameFilter extends ConsumerStatefulWidget {
  const GameFilter({Key? key}) : super(key: key);

  @override
  _GameFilterState createState() => _GameFilterState();
}

class _GameFilterState extends ConsumerState<GameFilter> {
  GameFilters? _gameFilters = GameFilters.active;

  void _setFilter(GameFilters? value) {
    ref.read(databaseProvider)!.gameFilters = value;
  }

  @override
  void initState() {
    super.initState();
    _gameFilters = ref.read(databaseProvider)!.gameFilters!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
      ),
      child: Row(
        children: [
          Radio<GameFilters>(
            value: GameFilters.active,
            groupValue: _gameFilters,
            onChanged: _setFilter,
          ),
          const Text('Active games'),
          Radio<GameFilters>(
            value: GameFilters.complete,
            groupValue: _gameFilters,
            onChanged: _setFilter,
          ),
          const Text('Completed games'),
        ],
      ),
    );
  }
}
