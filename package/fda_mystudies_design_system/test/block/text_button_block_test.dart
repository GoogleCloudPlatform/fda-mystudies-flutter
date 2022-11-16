import 'package:fda_mystudies_design_system/block/text_button_block.dart';
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
          TextButtonBlock(title: 'Enabled', onPressed: () {}),
          const TextButtonBlock(title: 'Disabled', onPressed: null)
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'text_button_block');
  });
}
