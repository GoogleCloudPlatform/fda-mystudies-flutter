abstract class ParticipantConsentDatastoreService {
  Future<Object> getConsentDocument(
      String userId, String authToken, String studyId);

  Future<Object> updateEligibilityAndConsentStatus(
      String userId,
      String authToken,
      String studyId,
      String siteId,
      String consentVersion,
      String base64Pdf,
      String userDataSharing);
}
