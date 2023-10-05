abstract class UserStudyEnrollmentJourney {
  // TODO: return an enum
  Future<Object> getEnrollmentStatus();

  Future<Object> validateEnrollmentToken({String enrollmentToken});

  Future<Object> getConsentDocument();

  Future<Object> getEligibilityAndConsent();

  Future<Object> finalizeEnrollmentInStudy();

  Future<Object> markUserAsNotEligible();

  Future<Object> markStudyCompleted();

  Future<Object> withdrawFromStudy();
}
