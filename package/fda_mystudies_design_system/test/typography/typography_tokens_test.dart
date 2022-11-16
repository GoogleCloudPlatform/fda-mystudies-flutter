import 'package:fda_mystudies_design_system/theme/dark_theme.dart';
import 'package:fda_mystudies_design_system/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'typography_tokens_test_widget.dart';

void main() {
  testGoldens('Typography Token should be displayed correctly in Light Theme',
      (tester) async {
    var testWidget = MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: LightTheme.getThemeData(),
        home: const TypographyTokensTestWidget());
    await tester.pumpWidgetBuilder(Center(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: testWidget,
      ),
    ));
    await screenMatchesGolden(tester, 'light.typography_tokens');
  });

  testGoldens('Typography Token should be displayed correctly in Dark Theme',
      (tester) async {
    var testWidget = MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: DarkTheme.getThemeData(),
        home: const TypographyTokensTestWidget());
    await tester.pumpWidgetBuilder(Center(
      child: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: testWidget,
      ),
    ));
    await screenMatchesGolden(tester, 'dark.typography_tokens');
  });
}
