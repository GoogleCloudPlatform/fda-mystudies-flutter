import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_settings/open_settings.dart';

class ConnectivityScenario {
  static void displayBrokenConnectionBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        leading: const Icon(Icons.wifi_off),
        content: Text(l10n.bannerBrokenConnectionMessage),
        actions: [
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: Text(l10n.bannerDismussButtonTitle)),
          TextButton(
              onPressed: () {
                OpenSettings.openWIFISetting();
              },
              child: Text(l10n.bannerConnectButtonTitle))
        ]));
  }

  static void hideBrokenConnectionBanner(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }
}
