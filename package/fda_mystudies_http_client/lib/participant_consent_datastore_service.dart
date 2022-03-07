import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/participant_consent_datastore_service/get_consent_document.pb.dart';
import 'package:fda_mystudies_spec/participant_consent_datastore_service/update_eligibility_consent_status.pb.dart';

abstract class ParticipantConsentDatastoreService {
  /// Download consent PDF from server by passing studyId.
  ///
  /// [GetConsentDocumentResponse] will consent document data for successful respnose.
  /// If type is HTML,content will be the HTML representation of the consent document
  /// as string. If type is PDF, content will be contents of PDF represented as base64
  /// encoded string.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getConsentDocument(String userId, String studyId);

  /// Update eligibility and consent status with signed consent PDF.
  ///
  /// [UpdateEligibilityConsentStatusResponse] for successful response. Returns url
  /// for the signed PDF consent form.
  /// [CommonErrorResponse] for failed response.
  Future<Object> updateEligibilityAndConsentStatus(
      String userId,
      String studyId,
      String siteId,
      String consentVersion,
      String base64Pdf,
      String userDataSharing);
}
