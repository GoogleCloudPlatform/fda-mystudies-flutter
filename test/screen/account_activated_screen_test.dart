import 'package:fda_mystudies/src/screen/account_activated_screen.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Account activated screen should be displayed correctly',
      (tester) async {
    final testWidget = AccountActivatedScreen(proceedToOnboarding: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'account_activated');
  });
}
