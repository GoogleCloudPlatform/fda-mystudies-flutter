import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';
import '../eligibility_module/eligibility_test.dart';
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
                      EligibilityDecision(
                          eligibility.type.eligibilityStepType, isEligible));
                }));
            break;
          case PbEligibilityStepType.test:
            push(context, const EligibilityTest());
            break;
          case PbEligibilityStepType.combined:
            push(
                context,
                EnrollmentToken(eligibility.tokenTitle, (isEligible) {
                  push(context, const EligibilityTest());
                }));
            break;
          default:
            break;
        }
      }
    });
  }
}
