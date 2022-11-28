import 'package:fda_mystudies/src/provider/welcome_provider.dart';
import 'package:fda_mystudies/src/screen/welcome_screen.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';

import '../test_util.dart';

void main() {
  const title = 'Conduct a health-study using FDA MyStudies app';
  const info =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. <b>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</b>';

  testGoldens('Welcome-screen should be displayed correctly', (tester) async {
    final testWidget = ChangeNotifierProvider<WelcomeProvider>(
        create: (_) => WelcomeProvider(title: title, info: info),
        child: WelcomeScreen(
            continueToSignIn: () {}, continueToOnboarding: () {}));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'welcome_screen');
  });

  testGoldens('Loading Welcome-screen should be displayed correctly',
      (tester) async {
    final testWidget = ChangeNotifierProvider<WelcomeProvider>(
        create: (_) => WelcomeProvider(title: title, info: info),
        child: const WelcomeScreen(
            displayShimmer: true,
            continueToSignIn: null,
            continueToOnboarding: null));

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'welcome_screen.loading');
  });
}
