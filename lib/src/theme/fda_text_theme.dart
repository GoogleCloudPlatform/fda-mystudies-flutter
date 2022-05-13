import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

class FDATextTheme {
  static TextStyle? headerTextStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle;
    }
    return Theme.of(context)
        .textTheme
        .headline4
        ?.apply(color: Theme.of(context).textTheme.bodyText1?.color);
  }

  static TextStyle? bodyTextStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.textStyle;
    }
    return Theme.of(context).textTheme.bodyText2?.apply(fontSizeFactor: 1.2);
  }
}
