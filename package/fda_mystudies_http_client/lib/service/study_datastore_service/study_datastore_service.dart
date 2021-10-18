abstract class StudyDatastoreService {
  Future<Object> getVersionInfo();

  Future<Object> getStudyList();

  Future<Object> fetchActivitySteps();

  Future<Object> getActivityList();

  Future<Object> getEligibilityAndConsent();

  Future<Object> getStudyInfo();

  Future<Object> getConsentDocument();

  Future<Object> getStudyDashboard();
}