abstract class ActivityStateStorageService {
  Future<void> upsert(
      {required String participantId,
      required String studyId,
      required String activityId,
      required DateTime recordedAt,
      required String state});

  Future<String> fetch(
      {required String participantId,
      required String studyId,
      required String activityId,
      required DateTime recordedAt});
}
