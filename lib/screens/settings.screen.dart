import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ui.provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Consumer<UI>(
          builder: (_, ui, __) => SwitchListTile.adaptive(
            onChanged: (val) => ui.toggleDarkMode(),
            value: ui.isDarkMode,
            title: const Text('Toggle Dark Mode'),
          ),
        ),
        OutlinedButton(
          onPressed: FirebaseAuth.instance.signOut,
          child: const Text('Sign out'),
        )
      ],
    );
  }
}
