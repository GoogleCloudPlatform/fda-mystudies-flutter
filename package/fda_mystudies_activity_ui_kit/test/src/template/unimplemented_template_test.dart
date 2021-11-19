import 'package:fda_mystudies_activity_ui_kit/src/template/unimplemented_template.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Unimplemented widget', (WidgetTester tester) async {
    await tester.pumpWidget(TestUtils.createWidgetForTesting(
        const UnimplementedTemplate('stepKey')));

    final scaffoldTitleFinder = find.text('Unimplemented stepKey');
    final bodyTextFinder = find.text(UnimplementedTemplate.pageContent);

    expect(scaffoldTitleFinder, findsOneWidget);
    expect(bodyTextFinder, findsOneWidget);
  });
}
