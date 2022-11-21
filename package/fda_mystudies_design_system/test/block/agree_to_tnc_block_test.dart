import 'package:fda_mystudies_design_system/block/agree_to_tnc_block.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('AgreeToTnCBlock should be displayed correctly when agreed',
      (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          AgreeToTnCBlock(
              agreedToTnC: true,
              termsAndConditionsURL: '',
              privacyPolicyURL: '',
              toggledAgreement: (_) {})
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'agree_to_tnc_block.agreed');
  });

  testGoldens('AgreeToTnCBlock should be displayed correctly when unagreed',
      (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          AgreeToTnCBlock(
              agreedToTnC: false,
              termsAndConditionsURL: '',
              privacyPolicyURL: '',
              toggledAgreement: (_) {})
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'agree_to_tnc_block.unagreed');
  });
}
