// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'models/user_data.model.dart';

import 'screens/auth.screen.dart';
import 'screens/create_game.screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, authSnapshot) => StreamProvider<UserData>.value(
        initialData: UserData.fromEmpty(),
        value: DatabaseService.getUserStream(authSnapshot.data?.uid),
        child: Consumer<UserData>(
          builder: (_, userData, __) => MaterialApp(
            title: 'Thirteen',
            theme: userData.isDarkMode ? darkTheme : lightTheme,
            home:
                authSnapshot.hasData ? const TabsScreen() : const AuthScreen(),
            routes: {
              CreateGameScreen.routeName: (ctx) => const CreateGameScreen(),
            },
          ),
        ),
      ),
    );
  }
}
