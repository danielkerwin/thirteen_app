import 'package:flutter/material.dart';

import 'game.screen.dart';

class GamesScreen extends StatelessWidget {
  static const routeName = '/games';
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      itemBuilder: (ctx, idx) => Card(
        child: ListTile(
          title: Text('Game $idx'),
          subtitle: Text('Created ${DateTime.now().toString()}'),
          onTap: () => Navigator.of(context).pushNamed(GameScreen.routeName),
        ),
      ),
    );
  }
}
