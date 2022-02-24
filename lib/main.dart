import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'providers/game.provider.dart';
import 'providers/ui.provider.dart';
import 'screens/game.screen.dart';
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
          return MaterialApp(
            title: 'Thirteen',
            theme: ui.isDarkMode ? darkTheme : lightTheme,
            home: const GameScreen(),
          );
        },
      ),
    );
  }
}
