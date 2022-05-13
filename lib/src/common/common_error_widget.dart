import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'widget_util.dart';

class CommonErrorWidget extends StatelessWidget {
  final String errorDescription;

  const CommonErrorWidget(this.errorDescription, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return Center(
          child: Text(errorDescription,
              textAlign: TextAlign.center,
              style:
                  CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle));
    }
    return Center(
        child: Text(errorDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).appBarTheme.titleTextStyle));
  }
}
