import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';
import '../widgets/main/main_hero.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String nickname,
    String password,
    bool isLogin,
  ) async {
    setState(() => _isLoading = true);
    UserCredential userData;
    final scaffold = ScaffoldMessenger.of(context);
    try {
      if (isLogin) {
        userData = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userData = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userData.user?.uid)
            .set(
          {'nickname': nickname, 'email': email, 'createdAt': Timestamp.now()},
        );
      }
    } on FirebaseAuthException catch (err) {
      print('FirebaseAuthException ${err.message}');
      print('FirebaseAuthException ${err.toString()}');
      scaffold.hideCurrentSnackBar();
      scaffold.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            err.message ?? 'Unknown error has occurred - please try again',
          ),
        ),
      );
      setState(() => _isLoading = false);
    } catch (err) {
      print('GenericError ${err.toString()}');
      scaffold.hideCurrentSnackBar();
      scaffold.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unknown error has occurred - please try again',
          ),
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppHero(),
            AuthForm(
              onSubmit: _submitAuthForm,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
