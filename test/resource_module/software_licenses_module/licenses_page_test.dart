import 'package:fda_mystudies/fda_mystudies_app.dart';
import 'package:fda_mystudies/src/resources_module/resources.dart';
import 'package:fda_mystudies/src/study_home.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util.dart';

void main() {
  setUpAll(() {
    configureDependencies(DemoConfig());
  });

  testWidgets('Show licenses page', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(TestUtil.wrapInMaterialApp(const StudyHome()));
      var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];
      await TestUtil.testSelectedTabViaScaffoldTitle(
          tester, tabs, resourcesTitle);
      expect(find.text(Resources.aboutTheStudyTitle), findsOneWidget);

      await tester.tap(find.text(Resources.softwareLicensesTitle));
      await tester.pump();
      await tester.pump();

      TestUtil.testScaffoldTitle('Licenses');
    });
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android, TargetPlatform.iOS}));
}
