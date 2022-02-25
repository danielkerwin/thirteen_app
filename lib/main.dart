import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'providers/game.provider.dart';
import 'providers/ui.provider.dart';
import 'screens/auth.screen.dart';
import 'screens/create_game.screen.dart';
import 'screens/game.screen.dart';
import 'screens/games.screen.dart';
import 'screens/scoreboard.screen.dart';
import 'screens/settings.screen.dart';
import 'screens/tabs.screen.dart';
import 'themes/dark.theme.dart';
import 'themes/light.theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UI>(create: (_) => UI()),
        ChangeNotifierProvider<Game>(create: (_) => Game()),
      ],
      child: Consumer<UI>(
        builder: (_, ui, __) {
          print('rebuilding');
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, authSnapshot) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Thirteen',
                theme: ui.isDarkMode ? darkTheme : lightTheme,
                home: authSnapshot.hasData
                    ? const TabsScreen()
                    : const AuthScreen(),
                routes: {
                  GamesScreen.routeName: (ctx) => const GamesScreen(),
                  GameScreen.routeName: (ctx) => const GameScreen(),
                  CreateGameScreen.routeName: (ctx) => const CreateGameScreen(),
                  ScoreboardScreen.routeName: (ctx) => const ScoreboardScreen(),
                  SettingsScreen.routeName: (ctx) => const SettingsScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
