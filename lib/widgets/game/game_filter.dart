import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/game.constants.dart';
import '../../providers/filter.provider.dart';

class GameFilter extends ConsumerWidget {
  final GameFilters filters;

  const GameFilter({
    Key? key,
    required this.filters,
  }) : super(key: key);

  void _setFilter(WidgetRef ref, GameFilters value) {
    ref.read(filterProvider).gameFilter = value;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
      ),
      child: Row(
        children: [
          Radio<GameFilters>(
            key: const ValueKey(GameFilters.active),
            value: GameFilters.active,
            groupValue: filters,
            onChanged: (val) => _setFilter(ref, val!),
          ),
          const Text('Active games'),
          Radio<GameFilters>(
            key: const ValueKey(GameFilters.complete),
            value: GameFilters.complete,
            groupValue: filters,
            onChanged: (val) => _setFilter(ref, val!),
          ),
          const Text('Completed games'),
        ],
      ),
    );
  }
}
