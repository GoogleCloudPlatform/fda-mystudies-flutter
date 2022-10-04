import 'package:flutter/material.dart';

class FDATextTheme {
  static TextStyle? headerTextStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .headline4
        ?.apply(color: Theme.of(context).textTheme.bodyText1?.color);
  }

  static TextStyle? bodyTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText2?.apply(fontSizeFactor: 1.2);
  }
}
