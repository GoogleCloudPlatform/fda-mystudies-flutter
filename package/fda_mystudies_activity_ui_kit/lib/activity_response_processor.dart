import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
abstract class ActivityResponseProcessor extends Widget {
  /// The final screen in the activity should implement this method.
  Future<void> processResponses(
      List<ActivityResponse_Data_StepResult> responses);
}
