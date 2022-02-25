import 'package:flutter/material.dart';

class GameError extends StatelessWidget {
  final String gameId;
  const GameError({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '#$gameId ',
                style: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const Text(
                'does not exist',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Go Back',
              style: TextStyle(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
