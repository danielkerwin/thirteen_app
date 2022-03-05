import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function(
    String email,
    String username,
    String password,
    bool isLogin,
  ) onSubmit;
  final bool isLoading;

  const AuthForm({
    Key? key,
    required this.onSubmit,
    required this.isLoading,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    await widget.onSubmit(
      _emailController.text.trim(),
      _nicknameController.text.trim(),
      _passwordController.text.trim(),
      _isLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Email address is required';
                      }
                      if (!val.contains('@')) {
                        return 'Must be a valid email adress';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(
                        labelText: 'Nickname',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Nickname is required';
                        }
                        if (val.length < 3 || val.length > 15) {
                          return 'Nickname must be between 3 to 15 characters';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Password is required';
                      }
                      if (val.length < 7) {
                        return 'Password must have at least 7 characters';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      controller: _passwordConfirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm password',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'You must confirm your password';
                        }
                        if (_passwordConfirmController.text !=
                            _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: widget.isLoading ? null : _trySubmit,
                    child: widget.isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : Text(
                            _isLogin ? 'Login' : 'Signup',
                          ),
                  ),
                  TextButton(
                    onPressed: widget.isLoading
                        ? null
                        : () => setState(() => _isLogin = !_isLogin),
                    child: Text(_isLogin ? 'Create new account' : 'Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
