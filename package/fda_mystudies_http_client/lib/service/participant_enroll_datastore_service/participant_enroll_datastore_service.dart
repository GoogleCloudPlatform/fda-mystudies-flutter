abstract class ParticipantEnrollDatastoreService {
  Future<Object> getStudyState();

  Future<Object> validateEnrollmentToken();

  Future<Object> updateStudyState();

  Future<Object> enrollInStudy();

  Future<Object> withdrawFromStudy();
}
