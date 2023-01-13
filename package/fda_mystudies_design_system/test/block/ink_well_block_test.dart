import 'package:fda_mystudies_design_system/block/ink_well_block.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('InkWellBlock should be displayed correctly', (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(
            children: [InkWellBlock(title: 'InkWell action', onTap: () {})]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'ink_well');
  });
}
