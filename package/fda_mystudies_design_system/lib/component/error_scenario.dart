import 'dart:io';

import 'package:flutter/material.dart';

class ErrorScenario {
  static void displayErrorMessage(BuildContext context, String message,
      {SnackBarAction? action}) {
    var isTestEnv = Platform.environment.containsKey('FLUTTER_TEST');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: isTestEnv
            ? const Duration(milliseconds: 200)
            : const Duration(seconds: 10),
        action: action));
  }
}
