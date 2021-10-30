abstract class StudyDatastoreService {
  Future<Object> getVersionInfo(String userId);

  Future<Object> getStudyList(String userId);

  Future<Object> fetchActivitySteps(
      String studyId, String activityId, String activityVersion, String userId);

  Future<Object> getActivityList(String studyId, String userId);

  Future<Object> getEligibilityAndConsent(String studyId, String userId);

  Future<Object> getStudyInfo(String studyId, String userId);

  Future<Object> getConsentDocument(String studyId, String userId);

  Future<Object> getStudyDashboard(String studyId);
}
