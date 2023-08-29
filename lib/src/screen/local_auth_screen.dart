import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../provider/local_auth_provider.dart';
import '../route/route_name.dart';

class LocalAuthScreen extends StatefulWidget {
  const LocalAuthScreen({Key? key}) : super(key: key);

  @override
  State<LocalAuthScreen> createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _displayLocalAuth();
  }

  Future<void> _displayLocalAuth() async {
    try {
      await auth
          .authenticate(
              localizedReason: 'Let OS determine authentication method',
              options: const AuthenticationOptions(stickyAuth: true))
          .then((isAuthenticated) {
        if (isAuthenticated) {
          auth.stopAuthentication();
          context.pop();
        } else {
          _displayLocalAuth();
        }
        return isAuthenticated;
      });
    } on PlatformException catch (e) {
      // TODO (chintanghate): fix this!
      // ignore: use_build_context_synchronously
      ErrorScenario.displayErrorMessageWithOKAction(context,
          e.message ?? 'Something went wrong while displaying lock screen');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false, child: const Scaffold());
  }
}

class LocalAuthObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name == RouteName.localAuthScreen) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        // This Delayed flip is done to avoid looped lock screen invocation on iOS devices.
        // Hacky solution: Since localAuthScreen will be pushed on top of an existing route,
        // this is safe to do, but a better solution needs to be found.
        Provider.of<LocalAuthProvider>(previousRoute!.navigator!.context,
                listen: false)
            .updateStatus(showLock: true);
      });
    }
    super.didPop(route, previousRoute);
  }
}
