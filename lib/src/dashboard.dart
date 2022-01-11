import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('Dashboard',
            style: Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
                : Theme.of(context).appBarTheme.titleTextStyle));
  }
}
