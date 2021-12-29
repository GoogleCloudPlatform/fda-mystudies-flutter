import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'src/study_home.dart';

class FDAMyStudiesApp extends StatelessWidget {
  const FDAMyStudiesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const CupertinoApp(
        title: 'FDA MyStudies',
        theme: CupertinoThemeData(),
        debugShowCheckedModeBanner: false,
        home: StudyHome(),
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
      home: const StudyHome(),
    );
  }
}
