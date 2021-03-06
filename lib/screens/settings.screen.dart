import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/database.provider.dart';
import '../providers/user_data.provider.dart';
import '../widgets/main/loading.dart';
import 'about.screen.dart';

class SettingsScreen extends ConsumerWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);
    return userDataAsync.when(
      error: (err, stack) => const Center(child: Text('Error')),
      loading: () => const Loading(),
      data: (user) => ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          SwitchListTile.adaptive(
            onChanged: (val) {
              ref.read(databaseProvider)!.toggleDarkMode(val);
            },
            value: user.isDarkMode,
            title: const Text('Toggle Dark Mode'),
          ),
          ListTile(
            title: const Text('About'),
            onTap: () => Navigator.of(context).pushNamed(AboutScreen.routeName),
          ),
          const Divider(),
          TextButton(
            onPressed: FirebaseAuth.instance.signOut,
            child: const Text('Sign out'),
          )
        ],
      ),
    );
  }
}
