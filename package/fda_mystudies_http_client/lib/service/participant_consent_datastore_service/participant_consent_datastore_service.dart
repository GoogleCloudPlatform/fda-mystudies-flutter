abstract class ParticipantConsentDatastoreService {
  Future<Object> getConsentDocument();

  Future<Object> updateEligibilityAndConsentStatus();
}