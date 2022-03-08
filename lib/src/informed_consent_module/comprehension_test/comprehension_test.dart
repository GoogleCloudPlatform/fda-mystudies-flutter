import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/widgets.dart';

import '../../user/user_data.dart';
import 'comprehesion_decision.dart';

class ComprehensionTest extends StatelessWidget {
  final GetEligibilityAndConsentResponse_Consent_Comprehension
      comprehensionTest;
  const ComprehensionTest(this.comprehensionTest, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userId = UserData.shared.userId;
    var studyId = UserData.shared.curStudyId;
    var activityId = 'comprehension-test';
    var uniqueId = '$userId:$studyId:$activityId';
    var activityBuilder = ui_kit.getIt<ActivityBuilder>();
    List<ActivityStep> steps = [
          ActivityStep.create()
            ..key = 'comprehension-overview'
            ..type = 'instruction'
            ..title = 'Comprehension'
            ..text =
                'Let\'s do a quick and simple test of your understanding of this Study.'
        ] +
        comprehensionTest.questions;
    return activityBuilder.buildActivity(
        steps,
        ComprehensionDecision(
            comprehensionTest.passScore, comprehensionTest.correctAnswers),
        uniqueId);
  }
}
