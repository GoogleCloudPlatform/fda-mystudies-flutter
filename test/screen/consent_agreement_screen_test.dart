import 'package:fda_mystudies/src/screen/consent_agreement_screen.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Consent Agreement screen should be displayed correctly',
      (tester) async {
    final testWidget = ConsentAgreementScreen(
        firstNameFieldController: TextEditingController(),
        lastNameFieldController: TextEditingController(),
        enableScrolling: false,
        signaturePoints: const [],
        updateSignature: (_) {},
        clearSignature: () {},
        updateScrollingBehavior: (_) {},
        continueToViewingConsentForm: () {},
        continueToConsentConfirmed: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'consent_agreement_screen');
  });
}
