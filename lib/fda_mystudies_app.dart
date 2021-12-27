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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const StudyHome(),
    );
  }
}
