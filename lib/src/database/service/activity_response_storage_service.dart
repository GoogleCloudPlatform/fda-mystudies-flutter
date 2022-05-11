import 'package:fda_mystudies_spec/database_model/activity_response.pb.dart';

abstract class ActivityResponseStorageService {
  Future<void> upsert(String participantId, String studyId, String activityId,
      String stepKey, DateTime recordedAt, String value);

  Future<List<ActivityResponse>> list(
      String participantId, String studyId, String activityId, String stepKey);
}
