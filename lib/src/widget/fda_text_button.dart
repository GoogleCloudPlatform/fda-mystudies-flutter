import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

class FDATextButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final Alignment? textAlignment;
  const FDATextButton(
      {required this.title, this.onPressed, this.textAlignment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return Expanded(
          child: CupertinoButton(
              child: Text(title),
              onPressed: onPressed,
              alignment: textAlignment ?? Alignment.center));
    }
    return TextButton(
      child: Text(title),
      onPressed: onPressed,
      style: ButtonStyle(alignment: textAlignment),
    );
  }
}
