import 'package:flutter/material.dart';

import 'game_user.dart';

class GameOpponents extends StatelessWidget {
  const GameOpponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        GameUser(
          username: 'Amita',
          cards: 2,
          isActive: true,
        ),
        GameUser(username: 'Grace', cards: 4),
        GameUser(username: 'Thyda', cards: 6),
      ],
    );
  }
}
