import 'package:fda_mystudies_design_system/typography/components/page_text.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../test_util.dart';

void main() {
  testGoldens('PageText should be displayed correctly', (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(padding: const EdgeInsets.all(24), children: const [
          PageText(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum')
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'page_text');
  });
}
