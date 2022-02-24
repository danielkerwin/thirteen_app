import 'package:flutter/material.dart';

class UI extends ChangeNotifier {
  bool _isDarkMode = false;

  get isDarkMode {
    return _isDarkMode;
  }

  void toggleDarkMode() {
    print('toggling dark mode');
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
