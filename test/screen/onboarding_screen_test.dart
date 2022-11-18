import 'package:fda_mystudies/src/screen/onboarding_screen.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  final List<String> onboardingSteps = [
    'Create your account',
    'Do eligibility survey to see if you are eligible for this study',
    'Do a simple comprehension survey to test our understanding of this study',
    'Consent agreement of sharing your data'
  ];

  testGoldens('Onboarding-screen should be displayed correctly',
      (tester) async {
    final testWidget = OnboardingScreen(
        onboardingSteps: onboardingSteps, continueToRegister: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'onboarding_screen');
  });
}
