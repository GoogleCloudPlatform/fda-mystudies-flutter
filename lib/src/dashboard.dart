import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('Dashboard',
            style: Platform.isIOS
                ? CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
                : Theme.of(context).appBarTheme.titleTextStyle));
  }
}
