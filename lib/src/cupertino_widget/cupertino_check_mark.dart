import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoCheckMark extends StatelessWidget {
  final bool value;
  final bool enabled;
  final void Function(bool) onTap;

  const CupertinoCheckMark(
      {required this.onTap, this.value = false, this.enabled = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var iconSize = 22 * scaleFactor;
    return GestureDetector(
        child: value
            ? Icon(CupertinoIcons.check_mark_circled_solid,
                color: enabled
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.inactiveGray,
                size: iconSize)
            : Icon(CupertinoIcons.circle,
                color: CupertinoColors.inactiveGray, size: iconSize),
        onTap: () {
          if (enabled) {
            onTap(!value);
          }
        });
  }
}
