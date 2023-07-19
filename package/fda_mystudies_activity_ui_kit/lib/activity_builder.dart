import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';

import 'activity_response_processor.dart';

abstract class ActivityBuilder {
  Widget buildActivity(
      List<ActivityStep> steps,
      ActivityResponseProcessor activityResponseProcessor,
      String uniqueActivityId,
      {bool allowExit = false,
      String? exitRouteName});

  Widget buildFailFastTest(
      {required List<ActivityStep> steps,
      required List<CorrectAnswers> answers,
      required ActivityResponseProcessor activityResponseProcessor,
      required String uniqueActivityId,
      bool allowExit = false,
      String? exitRouteName});
}
