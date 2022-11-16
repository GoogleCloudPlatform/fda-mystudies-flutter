import 'package:fda_mystudies_design_system/typography/components/heading.dart';
import 'package:fda_mystudies_design_system/typography/components/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../test_util.dart';

void main() {
  testGoldens('Heading & SubHeading should be displayed correctly',
      (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(
            padding: const EdgeInsets.all(24),
            children: const [Heading('Heading'), SubHeading('Sub-Heading')]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'heading_subheading');
  });
}
