import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';
import 'test_widget/error_scenario_test_widget.dart';

void main() {
  const errorMessage = 'Something went horribly wrong!';
  const errorButtonLabel = 'Show Error';

  testGoldens('Error Scenario should be displayed correctly in Light Theme',
      (tester) async {
    const testWidget = ErrorScenarioTestWidget(errorMessage: errorMessage);
    await TestUtil.testWidgetInLightTheme(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'error_scenario',
        action: () async {
          await tester.tap(find.text(errorButtonLabel).first);
          await tester.tap(find.text(errorButtonLabel).last);
          await tester.pump();
        });
  });

  testGoldens(
      'Error Scenario with action should be displayed correctly in Light Theme',
      (tester) async {
    final testWidget = ErrorScenarioTestWidget(
      errorMessage: errorMessage,
      action: SnackBarAction(label: 'Retry', onPressed: () {}),
    );
    await TestUtil.testWidgetInLightTheme(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'error_scenario.action',
        action: () async {
          await tester.tap(find.text(errorButtonLabel).first);
          await tester.tap(find.text(errorButtonLabel).last);
          await tester.pump();
        });
  });

  testGoldens('Error Scenario should be displayed correctly in Dark Theme',
      (tester) async {
    const testWidget = ErrorScenarioTestWidget(errorMessage: errorMessage);
    await TestUtil.testWidgetInDarkTheme(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'error_scenario',
        action: () async {
          await tester.tap(find.text(errorButtonLabel).first);
          await tester.tap(find.text(errorButtonLabel).last);
          await tester.pump();
        });
  });

  testGoldens(
      'Error Scenario with action should be displayed correctly in Dark Theme',
      (tester) async {
    final testWidget = ErrorScenarioTestWidget(
      errorMessage: errorMessage,
      action: SnackBarAction(label: 'Retry', onPressed: () {}),
    );
    await TestUtil.testWidgetInDarkTheme(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'error_scenario.action',
        action: () async {
          await tester.tap(find.text(errorButtonLabel).first);
          await tester.tap(find.text(errorButtonLabel).last);
          await tester.pump();
        });
  });
}
