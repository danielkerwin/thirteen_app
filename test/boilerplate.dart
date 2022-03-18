import 'package:flutter/material.dart';

Widget boilerplate(Widget screen) {
  return Directionality(
    child: MediaQuery(
      data: const MediaQueryData(),
      child: screen,
    ),
    textDirection: TextDirection.ltr,
  );
}
