import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'providers/auth.provider.dart';
import 'providers/providers.dart';
import 'providers/shared_pref.provider.dart';
import 'providers/user_data.provider.dart';
import 'screens/auth.screen.dart';
import 'screens/create_game.screen.dart';
import 'screens/game.screen.dart';
import 'screens/tabs.screen.dart';
import 'themes/dark.theme.dart';
import 'themes/light.theme.dart';
import 'widgets/main/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFunctions.instanceFor(region: 'australia-southeast1')
  //     .useFunctionsEmulator('localhost', 5001);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      observers: [if (kDebugMode) Logger()],
      overrides: [sharedPrefsProvider.overrideWithValue(sharedPrefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    Key? key,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateChangesProvider);
    final userDarkMode = ref.watch(
      userDataProvider.select((userData) => userData.value?.isDarkMode),
    );
    final prefsDarkMode = ref.read(sharedPrefsProvider).getBool('isDarkMode');
    final isDarkMode = userDarkMode ?? prefsDarkMode ?? false;

    return authStateAsync.when(
      data: (auth) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Thirteen',
          theme: isDarkMode ? darkTheme : lightTheme,
          home: auth == null ? const AuthScreen() : const TabsScreen(),
          routes: {
            CreateGameScreen.routeName: (ctx) => const CreateGameScreen(),
          },
          onGenerateRoute: (settings) {
            final uri = Uri.parse(settings.name!);

            switch (uri.path) {
              case GameScreen.routeName:
                final gameId = uri.queryParameters['id']!;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return GameScreen(gameId: gameId);
                  },
                  settings: settings,
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => const TabsScreen(),
                );
            }
          },
        );
      },
      loading: () => const Loading(),
      error: (err, stack) => const Center(child: CircularProgressIndicator()),
    );
  }
}
