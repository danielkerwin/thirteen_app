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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({
    Key? key,
    required this.prefs,
  }) : super(key: key);

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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        final isDarkMode = prefs.getBool('isDarkMode') ?? false;
        return StreamProvider<UserData>.value(
          initialData: UserData.fromEmpty(isDarkMode),
          value: DatabaseService.getUserStream(
            authSnapshot.data?.uid,
            isDarkMode,
          ),
          child: Consumer<UserData>(
            builder: (_, userData, __) {
              if (authSnapshot.hasData && userData.uid.isEmpty) {
                return Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? darkTheme.backgroundColor
                        : lightTheme.backgroundColor,
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Thirteen',
                theme: userData.isDarkMode ? darkTheme : lightTheme,
                home: authSnapshot.hasData && userData.uid.isNotEmpty
                    ? const TabsScreen()
                    : const AuthScreen(),
                routes: {
                  CreateGameScreen.routeName: (ctx) => const CreateGameScreen(),
                },
                onGenerateRoute: (settings) {
                  final uri = Uri.parse(settings.name!);

                  switch (uri.path) {
                    case GameScreen.routeName:
                      final gameId = uri.queryParameters['id'];
                      return Helpers.buildGameScreenRoute(
                        gameId!,
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
    );
  }
}
