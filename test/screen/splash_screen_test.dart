import 'package:fda_mystudies/src/screen/splash_screen.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Splash screen should be displayed correctly', (tester) async {
    const testWidget = SplashScreen();

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'splash_screen');
  });
}
