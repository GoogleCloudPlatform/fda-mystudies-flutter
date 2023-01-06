import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../common/widget_util.dart';
import '../route/route_name.dart';
import '../theme/fda_color_scheme.dart';
import '../theme/fda_text_style.dart';
import '../user/user_data.dart';

class DrawerMenu extends StatefulWidget {
  final void Function()? close;

  const DrawerMenu({this.close, Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 60),
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image(
                  image: const AssetImage('assets/images/logo.png'),
                  color: FDAColorScheme.googleBlue(context),
                  width: 36,
                  height: 33,
                ),
                const SizedBox(width: 12),
                Text(AppLocalizations.of(context).navigationBarTitle,
                    style: FDATextStyle.heading(context))
              ])),
          const SizedBox(height: 30),
          _listTile(
              context,
              Icons.home,
              AppLocalizations.of(context).homePage,
              GoRouter.of(context).location == '/${RouteName.studyHome}',
              () => context.goNamed(RouteName.studyHome)),
          const SizedBox(height: 8),
          _listTile(
              context,
              Icons.home,
              AppLocalizations.of(context).myAccountPage,
              GoRouter.of(context).location == '/${RouteName.myAccount}',
              () => context.goNamed(RouteName.myAccount)),
          const SizedBox(height: 8),
          _listTile(
              context,
              Icons.mail,
              AppLocalizations.of(context).reachOutPage,
              GoRouter.of(context).location == '/${RouteName.reachOut}',
              () => context.goNamed(RouteName.reachOut)),
          const SizedBox(height: 50),
          const Divider(),
          const SizedBox(height: 8),
          _listTile(
              context,
              Icons.exit_to_app,
              AppLocalizations.of(context).signOut,
              false,
              () => _showSignOutAlert(context)),
        ]);
  }

  Widget _listTile(BuildContext context, IconData icon, String title,
      bool isSelected, void Function()? onPressed,
      {String? subtitle}) {
    var color = isSelected ? const Color(0xFF0B57D0) : const Color(0xFF606060);
    return ListTile(
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        title: Row(children: [
          const SizedBox(width: 27),
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 27),
          Expanded(
              child: Text(title,
                  style: FDATextStyle.drawerNavigationItem(context)!
                      .apply(color: color)))
        ]),
        subtitle: subtitle == null
            ? null
            : Row(children: [
                const SizedBox(width: 72),
                Expanded(
                    child: Text(subtitle,
                        style:
                            FDATextStyle.drawerNavigationItemSubtitle(context)))
              ]),
        onTap: () {
          if (onPressed != null) {
            onPressed();
          }
        });
  }

  void _showSignOutAlert(BuildContext context) {
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
        context.goNamed(RouteName.root);
      }
      ErrorScenario.displayErrorMessage(context, response);
    });
  }

  void _clearStorageAndPreferences() {
    var securedStorage = const FlutterSecureStorage();
    securedStorage.deleteAll();
  }
}
