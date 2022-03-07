import 'package:flutter/material.dart';

import '../common/widget_util.dart';
import '../eligibility_module/eligibility_step_type_router.dart';
import 'study_tile/pb_study_enrollment_status.dart';
import 'study_tile/pb_user_study_data.dart';
import 'study_tile/pb_user_study_status.dart';

class StudyStatusRouter {
  static void nextStep(BuildContext context, PbUserStudyData pbUserStudyData) {
    if (pbUserStudyData.study.status.studyEnrollmentStatus ==
        PbStudyEnrollmentStatus.paused) {
      showUserMessage(context,
          'This study has been temporarily paused. Please check back later.');
      return;
    } else if (pbUserStudyData.study.status.studyEnrollmentStatus ==
        PbStudyEnrollmentStatus.closed) {
      showUserMessage(context, 'This study has been closed.');
      return;
    } else if (!pbUserStudyData.study.settings.enrolling &&
        (pbUserStudyData.userState.status.userStudyStatus ==
                PbUserStudyStatus.yetToEnroll ||
            pbUserStudyData.userState.status.userStudyStatus ==
                PbUserStudyStatus.withdrawn)) {
      showUserMessage(context,
          'Sorry, enrollment for this study has been closed for now. Please check back later.');
      return;
    } else if (pbUserStudyData.userState.status.userStudyStatus ==
        PbUserStudyStatus.notEligible) {
      showUserMessage(
          context, 'Sorry, you are not eligible to participate in this study!');
      return;
    } else if (pbUserStudyData.userState.status.userStudyStatus ==
            PbUserStudyStatus.yetToEnroll ||
        pbUserStudyData.userState.status.userStudyStatus ==
            PbUserStudyStatus.withdrawn) {
      EligibilityStepTypeRouter.nextStep(context);
      return;
    } else if (pbUserStudyData.userState.status.userStudyStatus ==
            PbUserStudyStatus.completed ||
        pbUserStudyData.userState.status.userStudyStatus ==
            PbUserStudyStatus.enrolled) {
      // Continue to Activities.
      return;
    }
  }
}
