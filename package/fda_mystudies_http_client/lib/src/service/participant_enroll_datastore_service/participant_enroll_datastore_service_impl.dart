import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/enroll_in_study.pbserver.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pbserver.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/validate_enrollment_token.pb.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../participant_enroll_datastore_service.dart';
import '../util/common_responses.dart';
import '../util/proto_json.dart';
import '../util/request_header.dart';
import '../util/response_parser.dart';
import '../config.dart';

@Injectable(as: ParticipantEnrollDatastoreService)
class ParticipantEnrollDatastoreServiceImpl
    implements ParticipantEnrollDatastoreService {
  // Base path
  static const participantEnrollDatastore = '/participant-enroll-datastore';

  // Endpoints
  static const studyStatePath = '/studyState';
  static const validateEnrollmentTokenPath = '/validateEnrollmentToken';
  static const updateStudyStatePath = '/updateStudyState';
  static const enrollPath = '/enroll';
  static const withdrawFromStudyPath = '/withdrawfromstudy';

  final http.Client client;
  final Config config;

  ParticipantEnrollDatastoreServiceImpl(this.client, this.config);

  @override
  Future<Object> enrollInStudy(
      String userId, String authToken, String enrollmentToken, String studyId) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId, authToken: authToken, contentType: ContentType.json);
    var queryParams = {'token': enrollmentToken, 'studyId': studyId};
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantEnrollDatastore$enrollPath', queryParams);

    return client.post(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('enroll', response,
            () => EnrollInStudyResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> getStudyState(String userId, String authToken) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authToken: authToken);
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantEnrollDatastore$studyStatePath');

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('study_state', response,
            () => GetStudyStateResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> updateStudyState(
      String userId,
      String authToken,
      String studyId,
      String studyStatus,
      String? siteId,
      String? participantId) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId, authToken: authToken, contentType: ContentType.json);
    var body = {
      'studies': [
        {
          'studyId': studyId,
          'status': studyStatus,
          'siteId': siteId,
          'participantId': participantId
        }
      ]
    };
    var queryParams = {'userId': userId};
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantEnrollDatastore$updateStudyStatePath', queryParams);

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'update_study_state',
            response,
            () => CommonResponses.successResponse));
  }

  @override
  Future<Object> validateEnrollmentToken(
      String userId, String authToken, String studyId, String enrollmentToken) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId, authToken: authToken, contentType: ContentType.json);
    var body = {'token': enrollmentToken, 'studyId': studyId};
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantEnrollDatastore$validateEnrollmentTokenPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'validate_enrollment_token',
            response,
            () => ValidateEnrollmentTokenResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> withdrawFromStudy(
      String userId, String authToken, String studyId, String participantId) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId, authToken: authToken, contentType: ContentType.json);
    var body = {
      'studyId': studyId,
      'delete': false,
      'participantId': participantId
    };
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantEnrollDatastore$withdrawFromStudyPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'withdraw_from_study',
            response,
            () => CommonResponses.successResponse));
  }
}
