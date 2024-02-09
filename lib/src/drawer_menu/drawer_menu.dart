import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../common/widget_util.dart';
import '../provider/local_auth_provider.dart';
import '../route/route_name.dart';
import '../user/user_data.dart';

class DrawerMenu extends StatefulWidget {
  final void Function()? cleanUp;

  const DrawerMenu({this.cleanUp, Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 60),
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image(
                  image: const AssetImage('assets/images/logo.png'),
                  color: Theme.of(context).colorScheme.primary,
                  width: 36,
                  height: 33,
                ),
                const SizedBox(width: 24),
                Expanded(
                child:Text(AppConfig.shared.currentConfig.appName,
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 2,))
              ])),
          const SizedBox(height: 30),
          _listTile(
              context,
              Icons.home,
              l10n.homePage,
              GoRouterState.of(context)
                      .fullPath
                      ?.startsWith('/${RouteName.studyHome}') ==
                  true,
              () => context.goNamed(RouteName.studyHome)),
          const SizedBox(height: 8),
          _listTile(
              context,
              Icons.account_circle,
              l10n.myAccountPage,
              GoRouterState.of(context).path == '/${RouteName.myAccount}',
              () => context.goNamed(RouteName.myAccount)),
          const SizedBox(height: 8),
          _listTile(
              context,
              Icons.mail,
              l10n.reachOutPage,
              GoRouterState.of(context).path == '/${RouteName.reachOut}',
              () => context.goNamed(RouteName.reachOut)),
          const SizedBox(height: 50),
          Divider(
            thickness: 1,
            color:
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          _listTile(context, Icons.exit_to_app, l10n.signOut, false,
              () => _showSignOutAlert(context)),
        ]);
  }

  Widget _listTile(BuildContext context, IconData icon, String title,
      bool isSelected, void Function()? onPressed,
      {String? subtitle}) {
    return ListTile(
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        title: Row(children: [
          const SizedBox(width: 27),
          Icon(icon, size: 18),
          const SizedBox(width: 27),
          Expanded(child: Text(title))
        ]),
        selectedTileColor: Theme.of(context).colorScheme.surfaceVariant,
        selectedColor: Theme.of(context).colorScheme.primary,
        selected: isSelected,
        subtitle: subtitle == null
            ? null
            : Row(children: [
                const SizedBox(width: 72),
                Expanded(child: Text(subtitle))
              ]),
        onTap: () {
          if (widget.cleanUp != null) {
            widget.cleanUp!();
          }
          if (onPressed != null) {
            onPressed();
          }
        });
  }

  void _showSignOutAlert(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var alertTitle = l10n.signOutAlertTitle;
    var alertContent = l10n.signOutAlertSubtitle;
    var alertDialog = AlertDialog(
      title: Text(alertTitle),
      content: Text(alertContent),
      actions: [
        TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            child: Text(l10n.signOutAlertCancel)),
        TextButton(
            onPressed: _isLoading ? null : () => _signOut(context),
            child: Text(l10n.signOutAlertConfirm)),
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<LocalAuthProvider>(context, listen: false)
                .updateStatus(showLock: false);
          });
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
