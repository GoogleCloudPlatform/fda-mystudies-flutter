import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';
import '../cupertino_widget/cupertino_check_mark.dart';

class FDACheckBox extends StatelessWidget {
  final bool value;
  final bool enabled;
  final void Function(bool) onTap;

  const FDACheckBox(
      {this.value = false, this.enabled = true, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoCheckMark(value: value, enabled: enabled, onTap: onTap);
    }
    return SizedBox(
        child: Checkbox(
            value: value,
            onChanged: (enabled
                ? (newValue) {
                    if (newValue != null) {
                      onTap(newValue);
                    }
                  }
                : null)),
        height: 22,
        width: 22);
  }
}
