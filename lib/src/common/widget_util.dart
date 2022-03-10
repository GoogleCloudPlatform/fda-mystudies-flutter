import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widget/fda_dialog_action.dart';

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

Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context, Widget widget) {
  if (isPlatformIos(context)) {
    return Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: ((BuildContext context) {
      return widget;
    })), (route) => false);
  }
  return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: ((BuildContext context) {
    return widget;
  })), (route) => false);
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

void showAdaptiveDialog(BuildContext context,
    {String? title,
    required String text,
    required List<FDADialogAction> actions}) {
  if (isPlatformIos(context)) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(text),
            actions: actions.cast<Widget>()));
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: title != null ? Text(title) : null,
              content: Text(text),
              actions: actions,
            ));
  }
}

void showWebviewModalBottomSheet(BuildContext context, String url) {
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  if (isPlatformIos(context)) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: WebView(initialUrl: url)),
                onPressed: () {},
              ),
              CupertinoActionSheetAction(
                child: const Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  } else {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.8,
              child: WebView(
                  initialUrl: url, gestureRecognizers: gestureRecognizers));
        });
  }
}
