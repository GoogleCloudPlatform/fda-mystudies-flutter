import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'main.dart';
import 'src/common/widget_util.dart';
import 'src/drawer_menu/drawer_menu.dart';
import 'src/my_account_module/my_account.dart';
import 'src/reach_out_module/reach_out.dart';
import 'src/register_and_login/welcome.dart';
import 'src/study_home.dart';
import 'src/user/user_data.dart';

class FDAMyStudiesApp extends StatelessWidget {
  static final androidLightTheme = ThemeData.light().copyWith(
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          toolbarTextStyle: const TextTheme(
                  subtitle1: TextStyle(color: Colors.black87, fontSize: 18),
                  subtitle2: TextStyle(color: Colors.black54, fontSize: 14))
              .bodyText2,
          titleTextStyle: const TextTheme(
                  subtitle1: TextStyle(color: Colors.black87, fontSize: 18),
                  subtitle2: TextStyle(color: Colors.black54, fontSize: 14))
              .headline6));

  static final androidDarkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.black,
      bottomNavigationBarTheme: ThemeData.light()
          .bottomNavigationBarTheme
          .copyWith(backgroundColor: Colors.black),
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
          foregroundColor: Colors.white, backgroundColor: Colors.black));
  const FDAMyStudiesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (curConfig.appType == AppType.standalone) {
      UserData.shared.curStudyId = curConfig.studyId;
    }
    if (isPlatformIos(context)) {
      return CupertinoApp(
        title: curConfig.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: const CupertinoThemeData(),
        debugShowCheckedModeBanner: false,
        initialRoute: Welcome.welcomeRoute,
        routes: {
          DrawerMenu.studyHomeRoute: (context) => const StudyHome(),
          DrawerMenu.myAccountRoute: (context) => const MyAccount(),
          DrawerMenu.reachOutRoute: (context) => const ReachOut(),
          Welcome.welcomeRoute: (context) => const Welcome(),
        },
        home: const Welcome(),
      );
    }
    return MaterialApp(
        title: curConfig.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.light().copyWith(
            appBarTheme: ThemeData.light().appBarTheme.copyWith(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white,
                toolbarTextStyle: const TextTheme(
                        subtitle1:
                            TextStyle(color: Colors.black87, fontSize: 18),
                        subtitle2:
                            TextStyle(color: Colors.black54, fontSize: 14))
                    .bodyText2,
                titleTextStyle: const TextTheme(
                        subtitle1:
                            TextStyle(color: Colors.black87, fontSize: 18),
                        subtitle2:
                            TextStyle(color: Colors.black54, fontSize: 14))
                    .headline6)),
        darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            cardColor: Colors.black,
            bottomNavigationBarTheme: ThemeData.light()
                .bottomNavigationBarTheme
                .copyWith(backgroundColor: Colors.black),
            appBarTheme: ThemeData.light()
                .appBarTheme
                .copyWith(foregroundColor: Colors.white, backgroundColor: Colors.black)),
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
