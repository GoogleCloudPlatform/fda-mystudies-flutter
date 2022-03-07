import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/enroll_in_study.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/validate_enrollment_token.pb.dart';

abstract class ParticipantEnrollDatastoreService {
  /// Get studies states with dashboard metadata (completion & adherence values).
  ///
  /// [GetStudyStateResponse] for successful response, contains list of studies,
  /// with state of each study containing enrollment data, siteId for the provided userId,
  /// adherence and completion statistics.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getStudyState(String userId);

  /// Validate enrollmentToken sent to the user email for enrolling in study with provided studyId.
  ///
  /// [ValidateEnrollmentTokenResponse] for successful response. Similar to CommonResponse.
  /// [CommonErrorResponse] for failed response.
  Future<Object> validateEnrollmentToken(
      String userId, String studyId, String enrollmentToken);

  /// Updates the states of the study with provided studyId.
  ///
  /// [CommonResponse] for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> updateStudyState(String userId, String studyId,
      String studyStatus, String? siteId, String? participantId);

  /// Enroll user with provided userId into study with provided studyId.
  ///
  /// [EnrollInStudyResponse] for successful response, contains siteId for the
  /// site user with provided userId is enrolled in.
  /// [CommonErrorResponse] for failed response.
  Future<Object> enrollInStudy(
      String userId, String enrollmentToken, String studyId);

  /// Withdraw user from the study with provided studyId.
  ///
  /// [CommonResponse] for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> withdrawFromStudy(
      String userId, String studyId, String participantId);
}
