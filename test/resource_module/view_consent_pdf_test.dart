import 'package:fda_mystudies/src/resources_module/resources.dart';
import 'package:fda_mystudies/src/study_home.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_util.dart';

void main() {
  setUpAll(() {
    configureDependencies(DemoConfig());
  });

  testWidgets('Show consent document page', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(TestUtil.wrapInMaterialApp(const StudyHome()));
      var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];
      await TestUtil.testSelectedTabViaScaffoldTitle(
          tester, tabs, resourcesTitle);
      expect(find.text(Resources.aboutTheStudyTitle), findsOneWidget);

      await tester.tap(find.text(Resources.consentPDFTitle));
      await tester.pump();
      await tester.pump();

      TestUtil.testScaffoldTitle('Signed Consent Document');
    });
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));
}
