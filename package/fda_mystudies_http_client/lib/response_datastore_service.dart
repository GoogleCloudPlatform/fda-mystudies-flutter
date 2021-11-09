import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';

abstract class ResponseDatastoreService {
  Future<Object> getActivityState(
      String userId, String authToken, String studyId, String participantId);

  Future<Object> updateActivityState(
      String userId,
      String authToken,
      String studyId,
      String participantId,
      GetActivityStateResponse_ActivityState activityState);

  Future<Object> processResponse(
      String userId, String authToken, ActivityResponse activityResponse);
}
