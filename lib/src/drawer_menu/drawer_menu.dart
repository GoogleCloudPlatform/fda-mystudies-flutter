import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/widget_util.dart';
import '../my_account_module/my_account.dart';
import '../reach_out_module/reach_out.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isIos = isPlatformIos(context);
    return ListView(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
        children: [
          Text('FDA MyStudies', style: _appNameStyle(context)),
          const SizedBox(height: 8),
          Text('Powered by FDA MyStudies on Google Cloud',
              style: _subtitleStyle(context)),
          SizedBox(height: isIos ? 150 : 100),
          _listTile(
              context, isIos ? CupertinoIcons.home : Icons.home, 'Home', () {}),
          _listTile(context, isIos ? CupertinoIcons.person : Icons.person,
              'My account', () => _navigateToMyAccount(context)),
          _listTile(context, isIos ? CupertinoIcons.mail : Icons.mail,
              'Reach out', () => _navigateToReachOut(context)),
          _listTile(context, Icons.exit_to_app, 'Sign out',
              () => _showSignOutAlert(context)),
        ]);
  }

  TextStyle? _appNameStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .navLargeTitleTextStyle
          .apply(fontSizeFactor: 0.8);
    }
    return Theme.of(context).textTheme.headline4;
  }

  TextStyle? _subtitleStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.tabLabelTextStyle;
    }
    return Theme.of(context).textTheme.caption;
  }

  Widget _listTile(BuildContext context, IconData icon, String title,
      void Function()? onPressed) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (isPlatformIos(context)) {
      return CupertinoButton(
          child: Row(children: [
            Icon(icon,
                size: 32,
                color: isDarkModeEnabled
                    ? CupertinoColors.extraLightBackgroundGray
                    : CupertinoColors.darkBackgroundGray),
            const SizedBox(width: 24),
            Text(title,
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .apply(fontSizeFactor: 1.5))
          ]),
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
          });
    }
    return ListTile(
        title: Row(children: [
          Icon(icon, size: 32),
          const SizedBox(width: 24),
          Text(title, style: Theme.of(context).textTheme.headline5)
        ]),
        onTap: () {
          if (onPressed != null) {
            onPressed();
          }
        });
  }

  void _navigateToMyAccount(BuildContext context) {
    push(context, const MyAccount());
  }

  void _navigateToReachOut(BuildContext context) {
    push(context, const ReachOut());
  }

  void _showSignOutAlert(BuildContext context) {
    const alertTitle = 'Sign out';
    const alertContent = 'Are you sure you want to sign out?';
    if (isPlatformIos(context)) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text(alertTitle),
                content: const Text(alertContent),
                actions: [
                  CupertinoDialogAction(
                      child: const Text('Sign out'),
                      onPressed: () {
                        // TODO (cg2092): Call Sign out API.
                      }),
                  CupertinoDialogAction(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop()),
                ],
              ));
    } else {
      var alertDialog = AlertDialog(
        title: const Text(alertTitle),
        content: const Text(alertContent),
        actions: [
          TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          TextButton(
              child: const Text('Sign out'),
              onPressed: () {
                // TODO (cg2092): Call Sign out API.
              }),
        ],
      );
      showDialog(
          context: context,
          builder: (context) {
            return alertDialog;
          });
    }
  }
}