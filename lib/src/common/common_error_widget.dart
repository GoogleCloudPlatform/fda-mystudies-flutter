import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonErrorWidget extends StatelessWidget {
  final String errorDescription;

  const CommonErrorWidget(this.errorDescription, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Center(
          child: Text(errorDescription,
              style:
                  CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle));
    }
    return Center(
        child: Text(errorDescription,
            style: Theme.of(context).appBarTheme.titleTextStyle));
  }
}
