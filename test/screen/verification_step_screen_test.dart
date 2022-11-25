import 'package:fda_mystudies/src/provider/my_account_provider.dart';
import 'package:fda_mystudies/src/screen/verification_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';

import '../test_util.dart';

void main() {
  testGoldens('Verification step screen should be displayed correctly',
      (tester) async {
    final testWidget = ChangeNotifierProvider<MyAccountProvider>(
        create: (_) => MyAccountProvider(email: 'test@gmail.com'),
        child: VerificationStepScreen(
            verificationCodeFieldController: TextEditingController(),
            verificationInProgress: false,
            verifyCode: () {},
            resendCode: () {}));

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'verification_step_screen');
  });
}
