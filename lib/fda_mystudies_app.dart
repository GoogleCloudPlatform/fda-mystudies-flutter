// import 'dart:developer' as developer;

import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';

import 'main.dart';
import 'src/drawer_menu/drawer_menu.dart';
import 'src/my_account_module/my_account.dart';
import 'src/reach_out_module/reach_out.dart';
import 'src/register_and_login/welcome.dart';
import 'src/study_home.dart';
import 'src/theme/fda_text_style.dart';
import 'src/user/user_data.dart';

class FDAMyStudiesApp extends StatefulWidget {
  const FDAMyStudiesApp({Key? key}) : super(key: key);

  @override
  State<FDAMyStudiesApp> createState() => _FDAMyStudiesAppState();
}

class _FDAMyStudiesAppState extends State<FDAMyStudiesApp>
    with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();
  // _SupportState _supportState = _SupportState.unknown;
  // bool? _canCheckBiometrics;
  // List<BiometricType>? _availableBiometrics;
  // String _authorized = 'Not Authorized';
  // bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // auth.isDeviceSupported().then(
    //       (bool isSupported) => setState(() => _supportState = isSupported
    //           ? _SupportState.supported
    //           : _SupportState.unsupported),
    //     );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   developer.log('state = $state');
  //   if (state == AppLifecycleState.resumed) {
  //     _authenticate();
  //   }
  // }

  // Future<void> _checkBiometrics() async {
  //   late bool canCheckBiometrics;
  //   try {
  //     canCheckBiometrics = await auth.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     canCheckBiometrics = false;
  //     developer.log(e.details);
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(() {
  //     _canCheckBiometrics = canCheckBiometrics;
  //   });
  // }

  // Future<void> _getAvailableBiometrics() async {
  //   late List<BiometricType> availableBiometrics;
  //   try {
  //     availableBiometrics = await auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     availableBiometrics = <BiometricType>[];
  //     developer.log(e.details);
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(() {
  //     _availableBiometrics = availableBiometrics;
  //   });
  // }

  // Future<void> _authenticate() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason: 'Let OS determine authentication method',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //       ),
  //     );
  //     setState(() {
  //       _isAuthenticating = false;
  //     });
  //   } on PlatformException catch (e) {
  //     developer.log(e.details);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Error - ${e.message}';
  //     });
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(
  //       () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  // }

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason:
  //           'Scan your fingerprint (or face or whatever) to authenticate',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //         biometricOnly: true,
  //       ),
  //     );
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Authenticating';
  //     });
  //   } on PlatformException catch (e) {
  //     developer.log(e.details);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Error - ${e.message}';
  //     });
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   final String message = authenticated ? 'Authorized' : 'Not Authorized';
  //   setState(() {
  //     _authorized = message;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (curConfig.appType == AppType.standalone) {
      UserData.shared.curStudyId = curConfig.studyId;
    }
    return MaterialApp(
        title: curConfig.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: ThemeData.light()
                .bottomNavigationBarTheme
                .copyWith(elevation: 0, backgroundColor: Colors.white),
            appBarTheme: ThemeData.light().appBarTheme.copyWith(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white,
                toolbarTextStyle: const TextTheme(
                        subtitle1:
                            TextStyle(color: Colors.black87, fontSize: 18),
                        subtitle2:
                            TextStyle(color: Colors.black54, fontSize: 14))
                    .bodyText2,
                titleTextStyle: FDATextStyle.appBarTitle(context))),
        // darkTheme: ThemeData.dark().copyWith(
        //     scaffoldBackgroundColor: Colors.black,
        //     cardColor: Colors.black,
        //     bottomNavigationBarTheme: ThemeData.light()
        //         .bottomNavigationBarTheme
        //         .copyWith(backgroundColor: Colors.black),
        //     appBarTheme: ThemeData.light().appBarTheme.copyWith(
        //         foregroundColor: Colors.white, backgroundColor: Colors.black)),
        debugShowCheckedModeBanner: false,
        initialRoute: Welcome.welcomeRoute,
        routes: {
          DrawerMenu.studyHomeRoute: (context) => const StudyHome(),
          DrawerMenu.myAccountRoute: (context) => const MyAccount(),
          DrawerMenu.reachOutRoute: (context) => const ReachOut(),
          Welcome.welcomeRoute: (context) => const Welcome(),
        });
  }
}

// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }
