import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/score.provider.dart';
import '../widgets/main/loading.dart';

class ScoreboardScreen extends ConsumerWidget {
  static const routeName = '/scoreboard';
  const ScoreboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(scoreProvider);

    return scoreAsync.when(
      data: (score) {
        final winRate = (score.gamesWon / score.gamesPlayed * 100);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Games played'),
                    trailing: Text(
                      score.gamesPlayed.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: const Text('Games won'),
                    trailing: Text(
                      score.gamesWon.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: const Text('Win rate'),
                    trailing: Text(
                      '${(winRate.isNaN ? 0 : winRate).toStringAsFixed(2)}%',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
      error: (err, stack) => const Center(child: Text('Error')),
      loading: () => const Loading(),
    );
  }
}
