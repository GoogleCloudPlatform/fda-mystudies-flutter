import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';
import 'test_widget/bottom_sheet_test_widget.dart';

void main() {
  testGoldens('Light Bottom Sheet should be displayed correctly',
      (tester) async {
    const testWidget = BottomSheetTestWidget();
    await TestUtil.testWidgetInLightTheme(
        tester: tester,
        testWidget: testWidget,
        action: () async {
          const buttonLabel = 'Show Bottom Sheet';
          await tester.tap(find.text(buttonLabel).first);
          await tester.tap(find.text(buttonLabel).last);
          await tester.pumpAndSettle();
        },
        widgetId: 'bottom_sheet');
  });

  testGoldens('Dark Bottom Sheet should be displayed correctly',
      (tester) async {
    const testWidget = BottomSheetTestWidget();
    await TestUtil.testWidgetInDarkTheme(
        tester: tester,
        testWidget: testWidget,
        action: () async {
          const buttonLabel = 'Show Bottom Sheet';
          await tester.tap(find.text(buttonLabel).first);
          await tester.tap(find.text(buttonLabel).last);
          await tester.pumpAndSettle();
        },
        widgetId: 'bottom_sheet');
  });
}
