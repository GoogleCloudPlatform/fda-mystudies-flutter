import 'package:fda_mystudies/src/screen/sharing_options_screen.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens('Sharing-options screen should be displayed correctly',
      (tester) async {
    final testWidget = SharingOptionsScreen(
        title: 'Sharing options',
        infoText: 'Please select how would you like for your data to be shared',
        options: const [
          'Share my data with qualified researchers worldwide',
          'Only share my data with the researchers conducting this study'
        ],
        selectedOption: null,
        updateSelection: (_) {},
        continueToNextScreen: () {});

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'sharing_options_screen');
  });
}
