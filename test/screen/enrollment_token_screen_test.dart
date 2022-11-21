import 'package:fda_mystudies/src/screen/enrollment_token_screen.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Enrollment Token screen should be displayed correctly',
      (tester) async {
    final testWidget = EnrollmentTokenScreen(
        enrollmentTokenFieldController: TextEditingController(),
        enrollmentTokenValidationInProgress: false,
        validateToken: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'enrollment_token_screen');
  });
}
