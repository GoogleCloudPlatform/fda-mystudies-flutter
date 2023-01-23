import 'package:fda_mystudies/src/screen/accessibility_screen.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Accessibility screen should be displayed correctly',
      (tester) async {
    final testWidget = AccessibilityScreen(
        readingPassage:
            '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam et mauris ligula. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris malesuada tortor et imperdiet suscipit.</p>',
        goToAccessibilitySettings: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'accessibility');
  });
}
