import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/widgets.dart';

import '../../common/widget_util.dart';
import 'visual_screen_template.dart';

class VisualScreen extends StatelessWidget {
  final List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
      visualScreens;
  final Widget finalScreen;
  const VisualScreen(this.visualScreens, this.finalScreen, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> visualScreenWidgets = [finalScreen];
    for (int i = visualScreens.length - 1; i >= 0; --i) {
      var nextScreen = visualScreenWidgets[0];
      if (visualScreens[i].visualStep) {
        visualScreenWidgets.insert(
            0,
            VisualScreenTemplate(visualScreens[i], () {
              push(context, nextScreen);
            }));
      }
    }

    return visualScreenWidgets[0];
  }
}
