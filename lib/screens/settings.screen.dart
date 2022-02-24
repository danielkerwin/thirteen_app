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
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      children: [
        Consumer<UI>(
          builder: (_, ui, __) => ListTile(
            leading: Switch.adaptive(
              value: ui.isDarkMode,
              onChanged: (val) => ui.toggleDarkMode(),
            ),
            title: const Text('Toggle Dark Mode'),
          ),
        ),
        const Divider(),
        OutlinedButton(
          onPressed: FirebaseAuth.instance.signOut,
          child: const Text('Sign out'),
        )
      ],
    );
  }
}
