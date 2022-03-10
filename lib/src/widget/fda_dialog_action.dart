import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/widget_util.dart';

class FDADialogAction extends StatelessWidget {
  final String title;
  final bool? isPrimary;
  final void Function()? onPressed;
  const FDADialogAction(this.title, {this.isPrimary, this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoDialogAction(
          child: Text(title),
          onPressed: onPressed,
          isDefaultAction: isPrimary ?? false);
    }
    return TextButton(
        child: Text(title),
        onPressed: onPressed,
        autofocus: isPrimary ?? false);
  }
}
