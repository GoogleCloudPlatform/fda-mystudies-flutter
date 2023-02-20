import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widget/fda_dialog_action.dart';

Future<T?> push<T extends Object?>(BuildContext context, Widget widget) {
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) {
    return widget;
  }));
}

Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context, Widget widget) {
  return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: ((BuildContext context) {
    return widget;
  })), (route) => false);
}

bool isPlatformIos(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

Color contrastingDividerColor(BuildContext context) {
  return Theme.of(context).scaffoldBackgroundColor;
}

String processResponse(dynamic response, String successfulMessage) {
  if (response is CommonErrorResponse) {
    var errorResponse = response.errorDescription;
    return errorResponse.isEmpty ? 'Something went wrong!' : errorResponse;
  }
  return successfulMessage;
}

void showUserMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void showAdaptiveDialog(BuildContext context,
    {String? title,
    required String text,
    required List<FDADialogAction> actions}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(text),
            actions: actions,
          ));
}

void showWebviewModalBottomSheet(BuildContext context,
    {String? url, String? htmlText}) {
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FractionallySizedBox(
            heightFactor: 0.75,
            child: WebView(
                initialUrl: url ?? _htmlContent(context, htmlText!),
                gestureRecognizers: gestureRecognizers));
      });
}

String _htmlContent(BuildContext context, String htmlText) {
  var bgColor = 'ffffff';
  var fgColor = '000000';

  var content = """<!DOCTYPE html>
                    <html>
                      <head><meta name="viewport" content="width=device-width, initial-scale=${MediaQuery.of(context).textScaleFactor}"></head>
                      <body style="margin: 0; padding: 16px;background-color: #$bgColor;color: #$fgColor">
                        <div>
                          ${parseFragment(htmlText).text}
                        </div>
                      </body>
                    </html>""";
  return Uri.dataFromString(content,
          mimeType: "text/html", encoding: Encoding.getByName('utf-8'))
      .toString();
}
