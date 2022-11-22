import 'package:fda_mystudies/src/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Register-screen should be displayed correctly', (tester) async {
    final testWidget = RegisterScreen(
        emailFieldController: TextEditingController(),
        passwordFieldController: TextEditingController(),
        confirmPasswordFieldController: TextEditingController(),
        registrationInProgress: false,
        agreedToTnC: false,
        toggledAgreement: (_) {},
        register: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'register_screen');
  });
}
