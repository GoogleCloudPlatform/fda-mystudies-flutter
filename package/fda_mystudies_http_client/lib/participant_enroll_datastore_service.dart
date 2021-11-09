abstract class ParticipantEnrollDatastoreService {
  Future<Object> getStudyState(String userId, String authToken);

  Future<Object> validateEnrollmentToken(
      String userId, String authToken, String studyId, String enrollmentToken);

  Future<Object> updateStudyState(
      String userId,
      String authToken,
      String studyId,
      String studyStatus,
      String? siteId,
      String? participantId);

  Future<Object> enrollInStudy(
      String userId, String authToken, String enrollmentToken, String studyId);

  Future<Object> withdrawFromStudy(
      String userId, String authToken, String studyId, String participantId);
}
