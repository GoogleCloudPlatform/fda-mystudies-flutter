import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/widget_util.dart';

class TimeModeButton extends StatelessWidget {
  final String mode;
  final bool isActive;
  final void Function() onPressed;

  const TimeModeButton(
      {required this.mode,
      required this.isActive,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return GestureDetector(
          onTap: () => onPressed(),
          child: Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              decoration: BoxDecoration(
                  color: isActive
                      ? CupertinoColors.activeBlue
                      : CupertinoTheme.of(context).barBackgroundColor,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text(mode, style: _statusStyle(context))));
    }
    return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).bottomAppBarColor,
                borderRadius: BorderRadius.circular(5.0)),
            child: Text(mode, style: _statusStyle(context))));
  }

  TextStyle? _statusStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.pickerTextStyle.apply(
          fontSizeFactor: 0.6,
          color: isActive
              ? CupertinoTheme.of(context).scaffoldBackgroundColor
              : CupertinoColors.activeBlue);
    }
    return Theme.of(context).textTheme.headline6?.apply(
        fontSizeFactor: 0.7,
        color: isActive ? Colors.white : Theme.of(context).colorScheme.primary);
  }
}
