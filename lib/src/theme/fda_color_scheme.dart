import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

class FDAColorScheme {
  static Color? primaryIconColor(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.textStyle.color;
    }
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color? bottomAppBarColor(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).barBackgroundColor;
    }
    return Theme.of(context).bottomAppBarColor;
  }
}
