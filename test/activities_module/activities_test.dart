import 'package:fda_mystudies/fda_mystudies_app.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_util.dart';

void main() {
  const completedActivityMessage = 'You have already completed this activity!';
  const questionnaireUITitle = 'Questionnaire to test all the UI Elements';
  const studyTaskTitle = 'Study Tasks';

  setUpAll(() {
    configureDependencies(DemoConfig());
  });

  testWidgets('Show Activities page and test completed message',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const FDAMyStudiesApp());
      var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];

      // Check activities tab is selected.
      await TestUtil.testSelectedTabViaScaffoldTitle(
          tester, tabs, activitiesTitle);

      // Test 2 activities are showing.
      expect(find.text(questionnaireUITitle), findsOneWidget);
      expect(find.text(studyTaskTitle), findsOneWidget);

      // Test Study Task is showing completed message when tapped.
      await tester.tap(find.text(studyTaskTitle));
      await tester.pumpAndSettle();
      expect(find.text(completedActivityMessage), findsOneWidget);
    });
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android, TargetPlatform.iOS}));
}
