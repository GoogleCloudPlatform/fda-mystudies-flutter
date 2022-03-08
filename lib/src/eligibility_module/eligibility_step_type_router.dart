import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';
import '../eligibility_module/enrollment_token.dart';
import '../user/user_data.dart';
import 'eligibility_decision.dart';
import 'pb_eligibility_step_type.dart';

class EligibilityStepTypeRouter {
  static Future<void> nextStep(BuildContext context) {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    return studyDatastoreService
        .getEligibilityAndConsent(
            UserData.shared.curStudyId, UserData.shared.userId)
        .then((value) {
      if (value is GetEligibilityAndConsentResponse) {
        var eligibility = value.eligibility;
        switch (eligibility.type.eligibilityStepType) {
          case PbEligibilityStepType.token:
            push(
                context,
                EnrollmentToken(eligibility.tokenTitle, (isEligible) {
                  push(
                      context,
                      EligibilityDecision(eligibility.correctAnswers,
                          eligibility.type.eligibilityStepType));
                }));
            break;
          case PbEligibilityStepType.test:
            _openActivityUI(context, eligibility);
            break;
          case PbEligibilityStepType.combined:
            push(
                context,
                EnrollmentToken(eligibility.tokenTitle, (isEligible) {
                  _openActivityUI(context, eligibility);
                }));
            break;
          default:
            break;
        }
      }
    });
  }

  static void _openActivityUI(BuildContext context,
      GetEligibilityAndConsentResponse_Eligibility eligibility) {
    var userId = UserData.shared.userId;
    var studyId = UserData.shared.curStudyId;
    var activityId = 'eligibility-test';
    var uniqueId = '$userId:$studyId:$activityId';
    var activityBuilder = ui_kit.getIt<ActivityBuilder>();
    List<ActivityStep> steps = [
          ActivityStep.create()
            ..key = 'info'
            ..type = 'instruction'
            ..title = 'Eligibility Test'
            ..text =
                'Please answer the questions that follow to help ascertain your eligibility for this study'
        ] +
        eligibility.tests;
    push(
        context,
        activityBuilder.buildActivity(
            steps,
            EligibilityDecision(eligibility.correctAnswers,
                eligibility.type.eligibilityStepType),
            uniqueId));
  }
}
