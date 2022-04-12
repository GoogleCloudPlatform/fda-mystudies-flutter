import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        child: SafeArea(
            child: ListView(
                padding: const EdgeInsets.all(12),
                children: <Widget>[
                      Text(
                          'You have chosen to delete your app account. This will result in automatic withdrawal from the sutdies you are enrolled in.',
                          style: _bodyStyle(context)),
                      const SizedBox(height: 32),
                    ] +
                    (isPlatformIos(context)
                        ? [
                            CupertinoButton(
                                child: const Text(
                                    'I agree, proceed to deleting my account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: CupertinoColors.white)),
                                color: CupertinoColors.destructiveRed,
                                onPressed: () {}),
                            const SizedBox(height: 16),
                            CupertinoButton.filled(
                                child: const Text(
                                    'I do not wish to delete my account',
                                    textAlign: TextAlign.center),
                                onPressed: () => Navigator.of(context).pop())
                          ]
                        : [
                            ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                    'I agree, proceed to deleting my account',
                                    textAlign: TextAlign.center),
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        Theme.of(context).colorScheme.error)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                    'I do not wish to delete my account',
                                    textAlign: TextAlign.center))
                          ]))),
        title: 'Delete Account',
        showDrawer: false);
  }

  TextStyle? _bodyStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.textStyle;
    }
    return Theme.of(context).textTheme.bodyText2?.apply(fontSizeFactor: 1.2);
  }
}
