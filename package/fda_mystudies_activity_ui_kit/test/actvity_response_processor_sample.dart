import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:flutter/widgets.dart';

class ActivityResponseProcessorSample extends StatelessWidget
    implements ActivityResponseProcessor {
  const ActivityResponseProcessorSample({Key? key}) : super(key: key);

  @override
  Future<void> processResponses(
      List<ActivityResponse_Data_StepResult> responses) {
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
