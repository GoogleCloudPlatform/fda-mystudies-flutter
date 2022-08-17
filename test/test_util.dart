import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

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

  static Widget wrapInMaterialApp(Widget widget) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget);
  }
}
