import 'package:fda_mystudies/src/provider/welcome_provider.dart';
import 'package:fda_mystudies/src/screen/study_intro_screen.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';

import '../test_util.dart';

void main() {
  testGoldens('StudyIntro screen should be displayed correctly',
      (tester) async {
    final testWidget = ChangeNotifierProvider<WelcomeProvider>(
        create: (_) => WelcomeProvider(
            title: '',
            info:
                'The FDA\'s MyStudies platform enables organizations to quickly build and deploy studies that interact with participants through purpose-built apps on iOS and Android.'),
        child: StudyIntroScreen(
            appName: 'FDA MyStudies',
            orgName: 'Google Cloud Platform',
            displayShimmer: false,
            participate: () {}));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'study_intro_screen');
  });
}
