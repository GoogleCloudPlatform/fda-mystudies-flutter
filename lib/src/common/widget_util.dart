import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<T?> push<T extends Object?>(BuildContext context, Widget widget) {
  if (isPlatformIos(context)) {
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: ((BuildContext context) {
      return widget;
    })));
  }
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) {
    return widget;
  }));
}

bool isPlatformIos(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

Color contrastingDividerColor(BuildContext context) {
  return isPlatformIos(context)
      ? CupertinoTheme.of(context).scaffoldBackgroundColor
      : Theme.of(context).scaffoldBackgroundColor;
}

Color dividerColor(BuildContext context) {
  return isPlatformIos(context)
      ? CupertinoTheme.of(context).barBackgroundColor
      : Theme.of(context).bottomAppBarColor;
}

String processResponse(dynamic response, String successfulMessage) {
  if (response is CommonErrorResponse) {
    var errorResponse = response.errorDescription;
    return errorResponse.isEmpty ? 'Something went wrong!' : errorResponse;
  }
  return successfulMessage;
}

void showUserMessage(BuildContext context, String message) {
  if (isPlatformIos(context)) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(message),
              actions: [
                CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop()),
              ],
            ));
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

bool validatePassword(String password) {
  if (password.length < 8) {
    return false;
  } else if (!password.contains(RegExp(r'[A-Z]'))) {
    return false;
  } else if (!password.contains(RegExp(r'[a-z]'))) {
    return false;
  } else if (!password.contains(RegExp(r'[0-9]'))) {
    return false;
  } else if (!(password
          .contains(RegExp(r'[!@#$%^&*()+=\-_~,.?":;{}|<>\[\]]')) ||
      password.contains('\''))) {
    return false;
  }
  return true;
}
