import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'src/common/widget_util.dart';
import 'src/drawer_menu/drawer_menu.dart';
import 'src/my_account_module/my_account.dart';
import 'src/reach_out_module/reach_out.dart';
import 'src/register_and_login/welcome.dart';
import 'src/study_home.dart';

class FDAMyStudiesApp extends StatelessWidget {
  const FDAMyStudiesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoApp(
        title: 'FDA MyStudies',
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
        title: 'FDA MyStudies',
        theme: ThemeData.light().copyWith(
            appBarTheme: ThemeData.light().appBarTheme.copyWith(
                textTheme: const TextTheme(
                    subtitle1: TextStyle(color: Colors.black87, fontSize: 18),
                    subtitle2: TextStyle(color: Colors.black54, fontSize: 14)),
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white)),
        darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            cardColor: Colors.black,
            bottomNavigationBarTheme: ThemeData.light()
                .bottomNavigationBarTheme
                .copyWith(backgroundColor: Colors.black),
            appBarTheme: ThemeData.light().appBarTheme.copyWith(
                foregroundColor: Colors.white, backgroundColor: Colors.black)),
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
