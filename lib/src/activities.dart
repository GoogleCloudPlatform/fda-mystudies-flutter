import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Activities extends StatelessWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('Activities',
            style: Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
                : Theme.of(context).appBarTheme.titleTextStyle));
  }
}
