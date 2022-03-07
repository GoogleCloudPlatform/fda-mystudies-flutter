import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';

/// Response server has all the logic related to Responses & Activity states.
abstract class ResponseDatastoreService {
  /// Return activities state.
  ///
  /// [GetActivityStateResponse] with all activities in the study for successful response.
  /// Contains current activity_run and state i.e. completed, in-progress
  /// or missed. Also the number of completed, missed and total runs for
  /// the activity.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getActivityState(
      String userId, String studyId, String participantId);

  /// Update state of activities and run information.
  ///
  /// [CommonResponse] when activity state updated successfully.
  /// [CommonErrorResponse] for failed response.
  Future<Object> updateActivityState(
      String userId,
      String authToken,
      String studyId,
      String participantId,
      GetActivityStateResponse_ActivityState activityState);

  /// Submit responses of an activity (questionnaire or active tasks).
  ///
  /// [CommonResponse] when responses submitted successfully.
  /// [CommonErrorResponse] for failed response.
  Future<Object> processResponse(
      String userId, String authToken, ActivityResponse activityResponse);
}
