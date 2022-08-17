import 'package:fda_mystudies/src/register_and_login/welcome.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../common/widget_util.dart';
import '../user/user_data.dart';

class DrawerMenu extends StatefulWidget {
  static const studyHomeRoute = '/studyHome';
  static const myAccountRoute = '/myAccount';
  static const reachOutRoute = '/reachOut';

  final void Function()? close;

  const DrawerMenu({this.close, Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var isIos = isPlatformIos(context);
    return ListView(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
        children: [
          Text(AppLocalizations.of(context).navigationBarTitle,
              style: _appNameStyle(context)),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context).navigationBarSubitle,
              style: _subtitleStyle(context)),
          SizedBox(height: isIos ? 150 : 100),
          _listTile(
              context,
              isIos ? CupertinoIcons.home : Icons.home,
              AppLocalizations.of(context).homePage,
              () => _navigateToStudyHome(context)),
          _listTile(
              context,
              isIos ? CupertinoIcons.person : Icons.person,
              AppLocalizations.of(context).myAccountPage,
              () => _navigateToMyAccount(context)),
          _listTile(
              context,
              isIos ? CupertinoIcons.mail : Icons.mail,
              AppLocalizations.of(context).reachOutPage,
              () => _navigateToReachOut(context)),
          _listTile(
              context,
              Icons.exit_to_app,
              AppLocalizations.of(context).signOut,
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
            Expanded(
                child: Text(title,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .apply(fontSizeFactor: 1.2)))
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
          Expanded(
              child: Text(title, style: Theme.of(context).textTheme.headline5))
        ]),
        onTap: () {
          if (onPressed != null) {
            onPressed();
          }
        });
  }

  void _navigateToStudyHome(BuildContext context) {
    _navigateToRoute(context, DrawerMenu.studyHomeRoute);
  }

  void _navigateToMyAccount(BuildContext context) {
    _navigateToRoute(context, DrawerMenu.myAccountRoute);
  }

  void _navigateToReachOut(BuildContext context) {
    _navigateToRoute(context, DrawerMenu.reachOutRoute);
  }

  void _navigateToRoute(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.of(context).pushReplacementNamed(routeName);
    } else {
      if (isPlatformIos(context)) {
        if (widget.close != null) {
          widget.close!();
        }
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  void _showSignOutAlert(BuildContext context) {
    var alertTitle = AppLocalizations.of(context).signOutAlertTitle;
    var alertContent = AppLocalizations.of(context).signOutAlertSubtitle;
    if (isPlatformIos(context)) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(alertTitle),
                content: Text(alertContent),
                actions: [
                  CupertinoDialogAction(
                      child: Text(
                          AppLocalizations.of(context).signOutAlertConfirm),
                      onPressed: _isLoading ? null : () => _signOut(context)),
                  CupertinoDialogAction(
                      child:
                          Text(AppLocalizations.of(context).signOutAlertCancel),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop()),
                ],
              ));
    } else {
      var alertTitle = AppLocalizations.of(context).signOutAlertTitle;
      var alertContent = AppLocalizations.of(context).signOutAlertSubtitle;
      var alertDialog = AlertDialog(
        title: Text(alertTitle),
        content: Text(alertContent),
        actions: [
          TextButton(
              child: Text(AppLocalizations.of(context).signOutAlertCancel),
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    }),
          TextButton(
              child: Text(AppLocalizations.of(context).signOutAlertConfirm),
              onPressed: _isLoading ? null : () => _signOut(context)),
        ],
      );
      showDialog(
          context: context,
          builder: (context) {
            return alertDialog;
          });
    }
  }

  void _signOut(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    var authenticationService = getIt<AuthenticationService>();
    authenticationService.logout(UserData.shared.userId).then((value) {
      const successfulResponse = 'Signed out';
      var response = processResponse(value, successfulResponse);
      setState(() {
        _isLoading = false;
        if (response == successfulResponse) {
          _clearStorageAndPreferences();
        }
      });
      if (response == successfulResponse) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Welcome.welcomeRoute, (route) => false);
      }
      showUserMessage(context, response);
    });
  }

  void _clearStorageAndPreferences() {
    var securedStorage = const FlutterSecureStorage();
    securedStorage.deleteAll();
  }
}
