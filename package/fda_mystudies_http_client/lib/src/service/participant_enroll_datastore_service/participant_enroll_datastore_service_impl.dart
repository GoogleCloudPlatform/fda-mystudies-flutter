import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/enroll_in_study.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/validate_enrollment_token.pb.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../participant_enroll_datastore_service.dart';
import '../../service/session.dart';
import '../util/common_responses.dart';
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
      String userId, String enrollmentToken, String studyId) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId,
          authToken: Session.shared.authToken,
          contentType: ContentType.json);
    var body = {'token': enrollmentToken, 'studyId': studyId};
    var uri = Uri.https(
        config.baseParticipantUrl, '$participantEnrollDatastore$enrollPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse('enroll', response,
            () => EnrollInStudyResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> getStudyState(String userId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authToken: Session.shared.authToken);
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantEnrollDatastore$studyStatePath');

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('study_state', response,
            () => GetStudyStateResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> updateStudyState(String userId, String studyId,
      {String? siteId,
      String? participantId,
      String? studyStatus,
      int? adherence,
      int? completion}) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId,
          authToken: Session.shared.authToken,
          contentType: ContentType.json);
    Map<String, dynamic> updatedStudy = {'studyId': studyId};
    if (siteId != null) {
      updatedStudy['siteId'] = siteId;
    }
    if (participantId != null) {
      updatedStudy['participantId'] = participantId;
    }
    if (adherence != null) {
      updatedStudy['adherence'] = adherence;
    }
    if (completion != null) {
      updatedStudy['completion'] = completion;
    }
    var body = {
      'studies': [updatedStudy]
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
      String userId, String studyId, String enrollmentToken) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId,
          authToken: Session.shared.authToken,
          contentType: ContentType.json);
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
      String userId, String studyId, String participantId) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId,
          authToken: Session.shared.authToken,
          contentType: ContentType.json);
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
