import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<T?> push<T extends Object?>(BuildContext context, Widget widget) {
  if (Platform.isIOS) {
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
