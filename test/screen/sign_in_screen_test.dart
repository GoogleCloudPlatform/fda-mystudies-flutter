import 'package:fda_mystudies/src/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Sign-in screen should be displayed correctly', (tester) async {
    final testWidget = SignInScreen(
        emailFieldController: TextEditingController(),
        passwordFieldController: TextEditingController(),
        signinInProgress: false,
        continueToForgotPasswordScreen: () {},
        signIn: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'sign_in_screen');
  });
}
