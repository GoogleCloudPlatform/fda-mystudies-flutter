import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

class CupertinoInkWell extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final void Function() onTap;

  const CupertinoInkWell(this.text,
      {this.textAlign, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap(),
        child: Text(text, textAlign: textAlign, style: _inkWellStyle(context)));
  }

  TextStyle? _style(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.textStyle;
    }
    return Theme.of(context).textTheme.bodyText1;
  }

  TextStyle? _inkWellStyle(BuildContext context) {
    return _style(context)?.apply(
        color: isPlatformIos(context)
            ? CupertinoTheme.of(context).primaryColor
            : Theme.of(context).colorScheme.primary);
  }
}
