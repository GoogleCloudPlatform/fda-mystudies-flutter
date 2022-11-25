import 'package:fda_mystudies/src/screen/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Reset-password screen should be displayed correctly',
      (tester) async {
    final testWidget = ResetPasswordScreen(
        temporaryPasswordTextFieldController: TextEditingController(),
        newPasswordTextFieldController: TextEditingController(),
        confirmPasswordTextFieldController: TextEditingController(),
        resetPassword: () {},
        resetPasswordInProgress: false);

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'reset_password_screen');
  });
}
