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
    final darkBuilder = DeviceBuilder()
      ..addScenario(
          widget: TestUtil.wrapInMaterialApp(const StudyHome(),
              useDarkTheme: true));
    await tester.pumpDeviceBuilder(darkBuilder);
    await screenMatchesGolden(tester, 'activity_home_dark');

    final lightBuilder = DeviceBuilder()
      ..addScenario(widget: TestUtil.wrapInMaterialApp(const StudyHome()));
    await tester.pumpDeviceBuilder(lightBuilder);
    await screenMatchesGolden(tester, 'activity_home_light');
  });
}
