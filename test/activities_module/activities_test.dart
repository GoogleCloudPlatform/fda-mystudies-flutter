import 'package:fda_mystudies/src/study_home.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  setUpAll(() {
    configureDependencies(DemoConfig());
  });

  testGoldens('Show Activities page in android', (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidget(TestUtil.wrapInMaterialApp(const StudyHome()));
    var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];

    // Check activities tab is selected.
    await TestUtil.testSelectedTabViaScaffoldTitle(
        tester, tabs, activitiesTitle);

    await screenMatchesGolden(tester, 'activity_home_android');
  });
}
