import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/async.dart';

import '../constants/nanoid.constant.dart';
import '../services/database.service.dart';
import 'game.screen.dart';

class CreateGameScreen extends StatefulWidget {
  static const routeName = '/create-game';

  const CreateGameScreen({Key? key}) : super(key: key);

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  bool _enableBombs = false;
  bool _enableInstantWins = false;
  bool _enableTimeLimit = false;

  @override
  void initState() {
    super.initState();
  }

  void _createGame() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final gameId = await customAlphabet(nanoidCharacters, 5);
    await DatabaseService.createGame(gameId, user.uid, userData['nickname']);

    Navigator.of(context).popAndPushNamed(
      '${GameScreen.routeName}?id=$gameId',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a new game',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _createGame,
                    child: const Text('Create game'),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                SwitchListTile.adaptive(
                  value: _enableBombs,
                  onChanged: null,
                  // onChanged: (val) => setState(
                  //   () => _enableBombs = !_enableBombs,
                  // ),
                  title: const Text('Enable bombs'),
                ),
                if (_enableBombs)
                  ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        value: true,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: null,
                        title: const Text('Bomb on 2\'s'),
                        subtitle: const Text(
                          'A valid bomb can only be played on 2\'s',
                        ),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        value: true,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: null,
                        title: const Text('Triple doubles (sequential)'),
                        subtitle: const Text('eg. 3,3,4,4,5,5'),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        value: true,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: null,
                        title: const Text('Four of a kind'),
                        subtitle: const Text('eg. 7,7,7,7'),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        value: true,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: null,
                        title: const Text('Pair & triple (sequential)'),
                        subtitle: const Text('eg. 4,4,5,5,5'),
                      ),
                    ],
                  ),
                if (_enableBombs) const Divider(),
                SwitchListTile.adaptive(
                  value: _enableInstantWins,
                  onChanged: null,
                  // onChanged: (val) => setState(
                  //   () => _enableInstantWins = !_enableInstantWins,
                  // ),
                  title: const Text('Enable instant wins'),
                ),
                if (_enableInstantWins)
                  ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        value: true,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: null,
                        title: const Text('Four 2\'s'),
                        subtitle: const Text('eg. 2,2,2,2'),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        value: true,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: null,
                        title: const Text('Six pairs'),
                        subtitle: const Text('eg. 3,3,5,5,8,8,9,9,J,J,10,10'),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        value: true,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: null,
                        title: const Text('Dragon'),
                        subtitle:
                            const Text('eg. 3 to A: 3,4,5,6,7,8,9,10,J,Q,K,A'),
                      ),
                    ],
                  ),
                if (_enableInstantWins) const Divider(),
                SwitchListTile.adaptive(
                  value: _enableTimeLimit,
                  onChanged: null,
                  // onChanged: (val) =>
                  //     setState(() => _enableTimeLimit = !_enableTimeLimit),
                  title: const Text('Enable time limits'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
