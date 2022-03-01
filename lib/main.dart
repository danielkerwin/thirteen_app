// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'helpers/helpers.dart';
import 'models/user_data.model.dart';

import 'screens/auth.screen.dart';
import 'screens/create_game.screen.dart';
import 'screens/game.screen.dart';
import 'screens/tabs.screen.dart';
import 'services/database.service.dart';
import 'themes/dark.theme.dart';
import 'themes/light.theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFunctions.instanceFor(region: 'australia-southeast1')
  //     .useFunctionsEmulator('localhost', 5001);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // final _router = GoRouter(
  //   routes: [
  //     GoRoute(
  //       path: '/',
  //       builder: (ctx, state) => const TabsScreen(),
  //     ),
  //     GoRoute(
  //       path: CreateGameScreen.routeName,
  //       builder: (ctx, state) => const CreateGameScreen(),
  //     ),
  //   ],
  // );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (_, prefs) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (prefs.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final isDarkMode = prefs.data!.getBool('isDarkMode') ?? false;
          return StreamProvider<UserData>.value(
            initialData: UserData.fromEmpty(isDarkMode),
            value: DatabaseService.getUserStream(
              authSnapshot.data?.uid,
              isDarkMode,
            ),
            child: Consumer<UserData>(
              builder: (__, userData, ___) {
                return MaterialApp(
                  title: 'Thirteen',
                  theme: userData.isDarkMode ? darkTheme : lightTheme,
                  home: authSnapshot.hasData
                      ? const TabsScreen()
                      : const AuthScreen(),
                  routes: {
                    CreateGameScreen.routeName: (ctx) =>
                        const CreateGameScreen(),
                  },
                  onGenerateRoute: (settings) {
                    final segments = settings.name!.split('?');
                    switch (segments[0]) {
                      case GameScreen.routeName:
                        final qs = segments[1].split('=');
                        return Helpers.buildGameScreenRoute(
                          qs[1],
                          authSnapshot.data?.uid ?? '',
                          settings,
                        );
                      default:
                        return MaterialPageRoute(
                          builder: (_) => const TabsScreen(),
                        );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
