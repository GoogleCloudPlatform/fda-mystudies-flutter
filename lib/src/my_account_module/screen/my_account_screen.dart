import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';

import '../../drawer_menu/drawer_menu.dart';

class MyAccountScreen extends StatelessWidget {
  final String username;
  final bool isLoading;
  final bool isBiometricEnabled;
  final bool isPushNotificationsEnabled;
  final bool isStudyActiviyReminderEnabled;
  final void Function() changePassword;
  final void Function() toggleBiometric;
  final void Function() togglePushNotifications;
  final void Function() toggleStudyActivityReminder;
  final void Function() deleteAppAccount;

  const MyAccountScreen(
      {required this.username,
      required this.isLoading,
      required this.isBiometricEnabled,
      required this.isPushNotificationsEnabled,
      required this.isStudyActiviyReminderEnabled,
      required this.changePassword,
      required this.toggleBiometric,
      required this.togglePushNotifications,
      required this.toggleStudyActivityReminder,
      required this.deleteAppAccount,
      super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myAccountPage)),
      drawer: Drawer(
          child: DrawerMenu(
              cleanUp: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar())),
      body: ListView(children: [
        ListTile(
            title: Text(l10n.myAccountUsernameLabel,
                style: Theme.of(context).textTheme.bodySmall),
            subtitle:
                Text(username, style: Theme.of(context).textTheme.titleMedium)),
        Divider(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ListTile(
            title: Text(l10n.myAccountPasswordLabel,
                style: Theme.of(context).textTheme.bodySmall),
            subtitle: InkWell(
                onTap: () => changePassword(),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Text(l10n.myAccountChangePasswordButtonLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.apply(
                            color: Theme.of(context).colorScheme.primary))))),
        Divider(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ListTile(
            title: Text(l10n.myAccountLocalAuthUserPermissionsLabel),
            trailing: isLoading
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: CircularProgressIndicator.adaptive())
                : Switch.adaptive(
                    value: isBiometricEnabled,
                    onChanged: (_) => toggleBiometric())),
        Divider(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ListTile(
            title: Text(l10n.myAccountLocalPushNotificationsPermissionsLabel),
            trailing: isLoading
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: CircularProgressIndicator.adaptive())
                : Switch.adaptive(
                    value: isPushNotificationsEnabled,
                    onChanged: (_) => togglePushNotifications())),
        Divider(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ListTile(
            title:
                Text(l10n.myAccountLocalStudyActivityRemindersPermissionsLabel),
            trailing: isLoading
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: CircularProgressIndicator.adaptive())
                : Switch.adaptive(
                    value: isStudyActiviyReminderEnabled,
                    onChanged: (_) => toggleStudyActivityReminder())),
        Divider(color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 48),
        PrimaryButtonBlock(
            title: l10n.myAccountDeleteAppAccountButtonLabel,
            onPressed: () => deleteAppAccount(),
            hasDestructiveAction: true)
      ]),
    );
  }
}
