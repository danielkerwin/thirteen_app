import 'package:flutter/material.dart';

import 'base.theme.dart';

final base = ThemeData(
  primarySwatch: Colors.green,
  brightness: Brightness.light,
  fontFamily: 'Roboto',
);

final lightTheme = base.copyWith(
  cardTheme: cardTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  iconTheme: IconThemeData(color: base.colorScheme.primary),
  colorScheme: base.colorScheme.copyWith(
    secondary: Colors.pink,
    onSecondary: Colors.white,
    tertiary: Colors.grey,
    onTertiary: Colors.white,
  ),
);
