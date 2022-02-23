import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'models/game_card.model.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UI>(
      create: (context) => UI(),
      child: Consumer<UI>(
        builder: (_, ui, __) {
          print('rebuilding');
          return MaterialApp(
            title: 'Thirteen',
            theme: ui.isDarkMode ? darkTheme : lightTheme,
            home: GameScreen(cards: [...gameCards]),
          );
        },
      ),
    );
  }
}
