import 'package:fda_mystudies/fda_mystudies_app.dart';
import 'package:fda_mystudies/src/study_home.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() {
    configureDependencies(DemoConfig());
  });

  testGoldens('Show Activities page in android', (WidgetTester tester) async {
    final builder = DeviceBuilder()..addScenario(widget: const StudyHome());

    await tester.pumpDeviceBuilder(builder,
        wrapper: materialAppWrapper(
            theme: FDAMyStudiesApp.androidLightTheme,
            localizations: AppLocalizations.localizationsDelegates,
            localeOverrides: AppLocalizations.supportedLocales));
    await screenMatchesGolden(tester, 'activity_home_light');
    await tester.pumpDeviceBuilder(builder,
        wrapper: materialAppWrapper(
            theme: FDAMyStudiesApp.androidDarkTheme,
            localizations: AppLocalizations.localizationsDelegates,
            localeOverrides: AppLocalizations.supportedLocales));
    await screenMatchesGolden(tester, 'activity_home_dark');
  });
}
