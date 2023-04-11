import 'package:fda_mystudies_design_system/block/page_html_text_block.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottomSheet {
  static void showWebview(BuildContext context,
      {String? url, String? htmlText}) {
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
                    child: _displayWidget(context, url, htmlText)),
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

  static Widget _displayWidget(
      BuildContext context, String? url, String? htmlText) {
    if (url != null && url.isNotEmpty) {
      final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
        Factory(() => EagerGestureRecognizer())
      };
      return WebView(
          backgroundColor: Theme.of(context).colorScheme.surface,
          initialUrl: url,
          gestureRecognizers: gestureRecognizers);
    } else if (htmlText != null && htmlText.isNotEmpty) {
      return ListView(children: [
        PageHtmlTextBlock(text: htmlText, textAlign: TextAlign.left)
      ]);
    }
    return Container();
  }
}
