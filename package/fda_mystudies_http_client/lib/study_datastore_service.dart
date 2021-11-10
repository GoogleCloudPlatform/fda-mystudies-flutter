import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_consent_document.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';

abstract class StudyDatastoreService {
  /// Return version of the app to check if the app needs to be updated.
  ///
  /// TODO(cg2092): Implementation needs to be corrected here.
  Future<Object> getVersionInfo(String userId);

  /// Return all configured studies.
  ///
  /// [GetStudyListResponse] with all configured studies for successful response.
  /// Each study will have data like title, id, version, status,
  /// also metadata like whether the study is enrolling new participants
  /// & platform (iOS, Android) the study is available on.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getStudyList(String userId);

  /// Return all qyestionnaires & activity tasks for the provided
  /// studyId & activityId.
  ///
  /// [FetchActivityStepsResponse] with all steps of an activity with given
  /// activityId & studyId for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> fetchActivitySteps(
      String studyId, String activityId, String activityVersion, String userId);

  /// Return all the activities for a study with the provided studyId.
  ///
  /// [GetActivityListResponse] with all activities in a study for successful respnose.
  /// Each activity in the list will have data like title, type, state & scheduling frequency.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getActivityList(String studyId, String userId);

  /// Return eligibility & consent info for the provided studyId.
  ///
  /// [GetEligibilityAndConsentResponse] for successful response, with data about the
  /// eligigbility test, comprehension test, consent document & sharing consent document.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getEligibilityAndConsent(String studyId, String userId);

  /// Return study metadata & configuration for the provided studyId.
  ///
  /// [StudyInfoResponse] for successful response, with data on study website,
  /// links to videos or images, and study description.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getStudyInfo(String studyId, String userId);

  /// Download consent PDF from server by passing studyId.
  ///
  /// [GetConsentDocumentResponse] will consent document data for successful respnose.
  /// If type is html,content will be the html representation of the consent document
  /// as string. If type is pdf, content will be contents of pdf represented as base64
  /// encoded string.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getConsentDocument(String studyId, String userId);

  /// Return dashboard metadata. Charts & Stats metadata for the provided
  /// studyId.
  ///
  /// [GetStudyDashboardResponse] for successful respnose, with charts and statistics
  /// that needed to be provided for the data collected in various activities in the study.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getStudyDashboard(String studyId);
}
