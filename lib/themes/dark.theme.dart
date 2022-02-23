import 'package:flutter/material.dart';

final base = ThemeData(
  primarySwatch: Colors.lightGreen,
  brightness: Brightness.dark,
  fontFamily: 'Roboto',
);

final darkTheme = base.copyWith(
  // buttonTheme: const ButtonThemeData(buttonColor: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),
  iconTheme: IconThemeData(color: base.colorScheme.primary),
  colorScheme: base.colorScheme.copyWith(
    secondary: Colors.deepPurple,
    onSecondary: Colors.white,
    tertiary: Colors.grey,
    onTertiary: Colors.white,
  ),
);
