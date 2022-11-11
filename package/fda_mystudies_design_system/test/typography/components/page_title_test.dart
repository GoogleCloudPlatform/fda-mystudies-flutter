import 'package:fda_mystudies_design_system/typography/components/page_title.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../test_util.dart';

void main() {
  testGoldens('PageTitle should be displayed correctly', (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(
            padding: const EdgeInsets.all(24),
            children: const [PageTitle(title: 'Page Title')]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'page_title');
  });
}
