import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';
import 'test_widget/connectivity_scenario_test_widget.dart';

void main() {
  const buttonLabel = 'Show Banner';

  testGoldens(
      'Connectivity Scenario should be displayed correctly in Light Theme',
      (tester) async {
    const testWidget = ConnectivityScenarioTestWidget();
    await TestUtil.testWidgetInLightTheme(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'connectivity_scenario',
        action: () async {
          await tester.tap(find.text(buttonLabel).first);
          await tester.tap(find.text(buttonLabel).last);
          await tester.pump();
        });
  });

  testGoldens(
      'Connectivity Scenario with action should be displayed correctly in Dark Theme',
      (tester) async {
    const testWidget = ConnectivityScenarioTestWidget();
    await TestUtil.testWidgetInDarkTheme(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'connectivity_scenario',
        action: () async {
          await tester.tap(find.text(buttonLabel).first);
          await tester.tap(find.text(buttonLabel).last);
          await tester.pump();
        });
  });
}
