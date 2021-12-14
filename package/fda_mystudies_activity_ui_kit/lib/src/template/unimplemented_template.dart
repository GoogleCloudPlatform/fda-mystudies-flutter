import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../injection/injection.dart';
import '../config.dart';

class UnimplementedTemplate extends StatelessWidget {
  static const pageContent = 'This activity type is not implemented yet!';

  final String stepKey;

  const UnimplementedTemplate(this.stepKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = 'Unimplemented $stepKey';
    if (getIt<Config>().isIOS) {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text(title)),
          child: Center(
              child: Text(pageContent,
                  textAlign: TextAlign.center,
                  style:
                      CupertinoTheme.of(context).textTheme.navTitleTextStyle)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
          child: Text(pageContent,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6)),
    );
  }
}
