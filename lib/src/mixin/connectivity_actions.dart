import 'package:fda_mystudies_design_system/component/connectivity_scenario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/connectivity_provider.dart';

mixin ConnectivityAction {
  void dispatchOnConnectivityChanges(
      BuildContext context, void Function() action) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _performActionIfConnected(context, action);
      Provider.of<ConnectivityProvider>(context, listen: false).addListener(() {
        _performActionIfConnected(context, action);
      });
    });
  }

  void _performActionIfConnected(BuildContext context, void Function() action) {
    if (Provider.of<ConnectivityProvider>(context, listen: false).isConnected) {
      ConnectivityScenario.hideBrokenConnectionBanner(context);
      action();
    } else {
      ConnectivityScenario.displayBrokenConnectionBanner(context);
    }
  }
}
