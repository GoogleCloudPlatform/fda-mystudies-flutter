import 'package:fda_mystudies_design_system/block/heading_block.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('HeadingBlock should be displayed correctly', (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(children: const [
          HeadingBlock(title: 'Heading occupies one to two lines')
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'heading_block');
  });

  testGoldens('HeadingBlock shimmer should be displayed correctly',
      (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(children: const [
          HeadingBlock(
              title: 'Heading occupies one to two lines', displayShimmer: true)
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'heading_block.shimmer');
  });
}
