import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottomSheet {
  static void showWebview(BuildContext context, {required String url}) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      Factory(() => EagerGestureRecognizer())
    };
    const radius = Radius.circular(16);
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.75,
              child: Stack(children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                            topLeft: radius, topRight: radius)),
                    child: url.isEmpty
                        ? Container()
                        : WebView(
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            initialUrl: url,
                            gestureRecognizers: gestureRecognizers)),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withOpacity(0.6),
                                size: 24,
                              ))
                        ]))
              ]));
        });
  }
}
