import 'package:fda_mystudies_design_system/typography/scaffold_title.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('ScaffoldTitle should be displayed correctly', (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(title: const ScaffoldTitle(title: 'Scaffold Title')));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'scaffold_title');
  });
}
