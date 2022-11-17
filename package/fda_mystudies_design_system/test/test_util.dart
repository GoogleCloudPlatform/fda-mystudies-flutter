import 'package:fda_mystudies_design_system/theme/dark_theme.dart';
import 'package:fda_mystudies_design_system/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class TestUtil {
  static Widget wrapInApp(Widget widget, {bool useDarkTheme = false}) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme:
            useDarkTheme ? DarkTheme.getThemeData() : LightTheme.getThemeData(),
        home: widget);
  }

  static Future<void> testWidgetInBothThemes(
      {required WidgetTester tester,
      required Widget testWidget,
      required String widgetId,
      Future<void> Function() action = _noAction}) async {
    await testWidgetInLightTheme(
        tester: tester,
        testWidget: testWidget,
        widgetId: widgetId,
        action: action);
    await testWidgetInDarkTheme(
        tester: tester,
        testWidget: testWidget,
        widgetId: widgetId,
        action: action);
  }

  static Future<void> testWidgetInLightTheme(
      {required WidgetTester tester,
      required Widget testWidget,
      required String widgetId,
      Future<void> Function() action = _noAction}) async {
    final lightBuilder = DeviceBuilder()
      ..addScenario(
          widget: TestUtil.wrapInApp(testWidget, useDarkTheme: false));
    await tester.pumpDeviceBuilder(lightBuilder);
    await action();
    await screenMatchesGolden(tester, 'light.$widgetId');
  }

  static Future<void> testWidgetInDarkTheme(
      {required WidgetTester tester,
      required Widget testWidget,
      required String widgetId,
      Future<void> Function() action = _noAction}) async {
    final darkBuilder = DeviceBuilder()
      ..addScenario(widget: TestUtil.wrapInApp(testWidget, useDarkTheme: true));
    await tester.pumpDeviceBuilder(darkBuilder);
    await action();
    await screenMatchesGolden(tester, 'dark.$widgetId');
  }

  static Future<void> _noAction() async {}

  static Future<void> tapIconButton(
      {required WidgetTester tester, required IconData icon}) async {
    for (final element in find.byIcon(icon).evaluate()) {
      await tester.tap(find.byWidget(element.widget));
      await tester.pump();
    }
  }
}
