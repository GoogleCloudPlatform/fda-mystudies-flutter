import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  static void displayErrorMessageWithOKAction(
      BuildContext context, String message) {
    displayErrorMessage(context, message,
        action: SnackBarAction(
            label: AppLocalizations.of(context)!.errorMessageOkayed,
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar()));
  }
}
