import 'package:fda_mystudies_design_system/theme/dark_theme.dart';
import 'package:fda_mystudies_design_system/theme/light_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

const activitiesTitle = 'Activities';
const dashboardTitle = 'Dashboard';
const resourcesTitle = 'Resources';

class TestUtil {
  static Finder findBottomBarItemWithLabel(String label) {
    if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
      return find.descendant(
          of: find.byWidgetPredicate((e) => e is CupertinoTabBar),
          matching: find.text(label));
    }
    return find.descendant(
        of: find.byWidgetPredicate((e) => e is BottomNavigationBar),
        matching: find.text(label));
  }

  static Future<void> testSelectedTabViaScaffoldTitle(
      WidgetTester tester, List<String> tabs, String text) async {
    await tester.tap(TestUtil.findBottomBarItemWithLabel(text));
    // This is done because pumpAndSettle doesn't work well with infinite
    // animation like progress indicator.
    for (int i = 0; i < 5; ++i) {
      await tester.pump(const Duration(seconds: 1));
    }
    for (String tab in tabs) {
      if (debugDefaultTargetPlatformOverride == TargetPlatform.android) {
        expect(find.widgetWithText(AppBar, tab),
            text == tab ? findsOneWidget : findsNothing);
      } else if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
        expect(find.widgetWithText(CupertinoNavigationBar, tab),
            text == tab ? findsOneWidget : findsNothing);
      }
    }
  }

  static void testScaffoldTitle(String title) async {
    if (debugDefaultTargetPlatformOverride == TargetPlatform.android) {
      expect(find.widgetWithText(AppBar, title), findsOneWidget);
    } else if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
      expect(
          find.widgetWithText(CupertinoNavigationBar, title), findsOneWidget);
    }
  }

  static Widget wrapInMaterialApp(Widget widget, {bool useDarkTheme = false}) {
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
          widget: TestUtil.wrapInMaterialApp(testWidget, useDarkTheme: false));
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
      ..addScenario(
          widget: TestUtil.wrapInMaterialApp(testWidget, useDarkTheme: true));
    await tester.pumpDeviceBuilder(darkBuilder);
    await action();
    await screenMatchesGolden(tester, 'dark.$widgetId');
  }

  static Future<void> _noAction() async {}
}
