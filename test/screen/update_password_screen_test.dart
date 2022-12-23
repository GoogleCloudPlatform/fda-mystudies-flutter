import 'package:fda_mystudies/src/screen/update_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Update temporary password screen should be displayed correctly',
      (tester) async {
    final testWidget = UpdatePasswordScreen(
        currentPasswordFieldController: TextEditingController(),
        newPasswordFieldController: TextEditingController(),
        repeatNewPasswordFieldController: TextEditingController(),
        isChangingTemporaryPassword: true,
        passwordUpdateInProgress: false,
        updatePassword: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'update_password_screen.temporary');
  });

  testGoldens('Update current password screen should be displayed correctly',
      (tester) async {
    final testWidget = UpdatePasswordScreen(
        currentPasswordFieldController: TextEditingController(),
        newPasswordFieldController: TextEditingController(),
        repeatNewPasswordFieldController: TextEditingController(),
        isChangingTemporaryPassword: false,
        passwordUpdateInProgress: false,
        updatePassword: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'update_password_screen.current');
  });
}
