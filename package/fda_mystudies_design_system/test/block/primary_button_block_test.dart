import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens(
      'PrimaryButtonBlock should be displayed correctly when enabled and disabled',
      (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          PrimaryButtonBlock(title: 'Enabled', onPressed: () {}),
          const PrimaryButtonBlock(title: 'Disabled', onPressed: null)
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'primary_button_block');
  });
}
