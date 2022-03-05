import 'package:flutter/material.dart';

class Helpers {
  static SnackBar getSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(fontFamily: 'Roboto'),
      ),
    );
  }
}
