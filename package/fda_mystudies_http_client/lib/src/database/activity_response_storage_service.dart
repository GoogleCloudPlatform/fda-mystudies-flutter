import 'package:fda_mystudies_spec/database_model/activity_response.pb.dart';

abstract class ActivityResponseStorageService {
  Future<void> upsert(
      {required String participantId,
      required String studyId,
      required String activityId,
      required String stepKey,
      required DateTime recordedAt,
      required String value});

  Future<List<ActivityResponse>> list(
      {required String participantId,
      required String studyId,
      required String activityId,
      required String stepKey});
}
