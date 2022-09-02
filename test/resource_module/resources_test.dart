import 'package:fda_mystudies/src/resources_module/resources.dart';
import 'package:fda_mystudies/src/study_home.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_util.dart';

void main() {
  setUpAll(() {
    configureDependencies(DemoConfig());
  });

  testWidgets('Show Resources page', (WidgetTester tester) async {
    await tester.pumpWidget(TestUtil.wrapInMaterialApp(const StudyHome()));
    var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];
    await TestUtil.testSelectedTabViaScaffoldTitle(
        tester, tabs, resourcesTitle);
    expect(find.text(Resources.aboutTheStudyTitle), findsOneWidget);
    expect(find.text(Resources.softwareLicensesTitle), findsOneWidget);
    expect(find.text(Resources.consentPDFTitle), findsOneWidget);
    expect(find.text(Resources.leaveStudyTitle), findsOneWidget);
    expect(find.text(Resources.leaveStudySubtitle), findsOneWidget);
    expect(find.text(Resources.environmentTitle), findsOneWidget);
    expect(find.text(Resources.environmentSubtitle), findsOneWidget);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('Show leave study dialog', (WidgetTester tester) async {
    await tester.pumpWidget(TestUtil.wrapInMaterialApp(const StudyHome()));
    var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];
    await TestUtil.testSelectedTabViaScaffoldTitle(
        tester, tabs, resourcesTitle);
    expect(find.text(Resources.aboutTheStudyTitle), findsOneWidget);

    await tester.tap(find.text(Resources.leaveStudyTitle));
    await tester.pump();

    const leaveStudyDialogTitle = 'Are you sure you want to leave the study?';
    expect(find.text(leaveStudyDialogTitle), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(find.text(leaveStudyDialogTitle), findsNothing);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));
}
