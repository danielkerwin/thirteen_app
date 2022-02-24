import 'package:flutter/material.dart';

import 'game.screen.dart';

class CreateGameScreen extends StatefulWidget {
  static const routeName = '/create-game';

  const CreateGameScreen({Key? key}) : super(key: key);

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  bool _enableBombs = false;
  bool _enableTimeLimit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a game',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Game name'),
          ),
          ListTile(
            leading: Switch.adaptive(
              value: _enableBombs,
              onChanged: (val) => setState(() => _enableBombs = !_enableBombs),
            ),
            title: const Text('Enable bombs'),
            trailing: const IconButton(
              icon: Icon(Icons.arrow_drop_down),
              onPressed: null,
            ),
          ),
          ListTile(
            leading: Switch.adaptive(
              value: _enableTimeLimit,
              onChanged: (val) =>
                  setState(() => _enableTimeLimit = !_enableTimeLimit),
            ),
            title: const Text('Enable time limits'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).popAndPushNamed(GameScreen.routeName),
            child: const Text('Create game'),
          )
        ],
      ),
    );
  }
}
