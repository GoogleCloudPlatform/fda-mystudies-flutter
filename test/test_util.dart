import 'package:fda_mystudies/fda_mystudies_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const activitiesTitle = 'Activities';
const dashboardTitle = 'Dashboard';
const resourcesTitle = 'Resources';

class TestUtil {
  static Finder findBottomBarItemWithLabel(String label) {
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
      expect(find.widgetWithText(AppBar, tab),
          text == tab ? findsOneWidget : findsNothing);
    }
  }

  static void testScaffoldTitle(String title) async {
    expect(find.widgetWithText(AppBar, title), findsOneWidget);
  }

  static Widget wrapInMaterialApp(Widget widget, {bool useDarkTheme = false}) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: useDarkTheme
            ? FDAMyStudiesApp.androidDarkTheme
            : FDAMyStudiesApp.androidLightTheme,
        home: widget);
  }
}
