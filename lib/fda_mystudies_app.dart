import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_design_system/theme/dark_theme.dart';
import 'package:fda_mystudies_design_system/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'src/provider/connectivity_provider.dart';
import 'src/route/app_router.dart';

class FDAMyStudiesApp extends StatefulWidget {
  const FDAMyStudiesApp({Key? key}) : super(key: key);

  @override
  State<FDAMyStudiesApp> createState() => _FDAMyStudiesAppState();
}

class _FDAMyStudiesAppState extends State<FDAMyStudiesApp>
    with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();
  final LocalAuthentication auth = LocalAuthentication();
  var _isAuthenticating = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_isAuthenticating) {
      return;
    }
    if (state == AppLifecycleState.resumed) {
      developer.log('APP LIFECYCLE STATE: RESUMED');
      _displayLocalAuth();
    } else if (state != AppLifecycleState.resumed) {
      developer.log('APP LIFECYCLE STATE: ${state.toString()}');
    }
  }

  Future<void> _displayLocalAuth() async {
    try {
      setState(() {
        _isAuthenticating = true;
      });
      await auth
          .authenticate(
              localizedReason: 'Let OS determine authentication method',
              options: const AuthenticationOptions(stickyAuth: true))
          .then((isAuthenticated) {
        if (isAuthenticated) {
          auth.stopAuthentication();
        }
        return true;
      });
      Future.delayed(const Duration(seconds: 1)).then(((value) => setState(() {
            _isAuthenticating = false;
          })));
    } on PlatformException catch (e) {
      ErrorScenario.displayErrorMessageWithOKAction(context,
          e.message ?? 'Something went wrong while displaying lock screen');
      setState(() {
        _isAuthenticating = false;
      });
      return;
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    Provider.of<ConnectivityProvider>(context, listen: false)
        .updateStatus(result: result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: curConfig.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: LightTheme.getThemeData(),
        darkTheme: DarkTheme.getThemeData(),
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.routeConfig);
  }
}
