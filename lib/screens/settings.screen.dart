import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_data.model.dart';
import '../services/database.service.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build settings_screen');
    final userData = Provider.of<UserData>(context);

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        SwitchListTile.adaptive(
          onChanged: (val) => DatabaseService.toggleDarkMode(userData.uid, val),
          value: userData.isDarkMode,
          title: const Text('Toggle Dark Mode'),
        ),
        OutlinedButton(
          onPressed: FirebaseAuth.instance.signOut,
          child: const Text('Sign out'),
        )
      ],
    );
  }
}
