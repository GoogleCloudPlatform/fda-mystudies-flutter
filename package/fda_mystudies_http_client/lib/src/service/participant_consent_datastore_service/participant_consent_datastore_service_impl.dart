import 'dart:convert';

import 'package:fda_mystudies_http_client/src/service/session.dart';
import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:fda_mystudies_spec/participant_consent_datastore_service/get_consent_document.pb.dart';
import 'package:fda_mystudies_spec/participant_consent_datastore_service/update_eligibility_consent_status.pb.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../config.dart';
import '../../../participant_consent_datastore_service.dart';
import '../util/request_header.dart';
import '../util/response_parser.dart';

@Injectable(as: ParticipantConsentDatastoreService)
class ParticipantConsentDatastoreServiceImpl
    implements ParticipantConsentDatastoreService {
  // Base path
  static const participantConsentDatastore = '/participant-consent-datastore';

  // Endpoints
  static const consentDocumentPath = '/consentDocument';
  static const updateEligibilityConsentStatusPath =
      '/updateEligibilityConsentStatus';

  final http.Client client;
  final Config config;

  ParticipantConsentDatastoreServiceImpl(this.client, this.config);

  @override
  Future<Object> getConsentDocument(String userId, String studyId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authToken: Session.shared.authToken);
    var queryParams = {'studyId': studyId, 'consentVersion': ''};
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantConsentDatastore$consentDocumentPath', queryParams);

    return client
        .get(uri, headers: headers.toHeaderJson())
        .then((response) => ResponseParser.parseHttpResponse(
            'consent_document',
            response,
            () => GetConsentDocumentResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> updateEligibilityAndConsentStatus(
      String userId,
      String studyId,
      String siteId,
      String consentVersion,
      String base64Pdf,
      String userDataSharing) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId,
          authToken: Session.shared.authToken,
          contentType: ContentType.json);
    var body = {
      'studyId': studyId,
      'eligibility': true,
      'siteId': siteId,
      'consent': {
        'version': consentVersion,
        'status': 'completed',
        'pdf': base64Pdf
      },
      'sharing': userDataSharing
    };
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantConsentDatastore$updateEligibilityConsentStatusPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'update_eligibility_consent_status',
            response,
            () => UpdateEligibilityConsentStatusResponse()
              ..fromJson(response.body)));
  }
}
