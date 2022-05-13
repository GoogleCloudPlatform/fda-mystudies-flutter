import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';
import '../cupertino_widget/cupertino_ink_well.dart';
import '../theme/fda_text_theme.dart';

class FDAInkWell extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const FDAInkWell(this.text, {this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoInkWell(text, onTap: onTap);
    }
    return InkWell(
        child: Text(text,
            style: FDATextTheme.bodyTextStyle(context)
                ?.apply(color: Theme.of(context).colorScheme.primary)),
        onTap: onTap);
  }
}
