import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

import 'activity_response_processor.dart';

abstract class ActivityBuilder {
  Widget buildActivity(
      List<ActivityStep> steps,
      ActivityResponseProcessor activityResponseProcessor,
      String uniqueActivityId,
      {bool allowExit = false,
      String? exitRouteName});
}
