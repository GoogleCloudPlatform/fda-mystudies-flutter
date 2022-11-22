import 'package:fda_mystudies/src/screen/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Forgot-password screen should be displayed correctly',
      (tester) async {
    final testWidget = ForgotPasswordScreen(
        emailFieldController: TextEditingController(),
        forgotPassword: () {},
        forgotPasswordInProgress: false);

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'forgot_password_screen');
  });
}
