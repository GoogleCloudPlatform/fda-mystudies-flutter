import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/get_user_profile.pb.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/registration.pb.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/update_user_profile.pb.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/verify_email.pb.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../config.dart';
import '../../../participant_user_datastore_service.dart';
import '../util/common_responses.dart';
import '../util/proto_json.dart';
import '../util/request_header.dart';
import '../util/response_parser.dart';

@Injectable(as: ParticipantUserDatastoreService)
class ParticipantUserDatastoreServiceImpl
    implements ParticipantUserDatastoreService {
  // Base path
  static const participantUserDatastore = '/participant-user-datastore';

  // Endpoints
  static const registerPath = '/register';
  static const verifyEmailPath = '/verifyEmailId';
  static const resendConfirmationPath = '/resendConfirmation';
  static const userProfilePath = '/userProfile';
  static const updateUserProfilePath = '/updateUserProfile';
  static const feedbackPath = '/feedback';
  static const contactUsPath = '/contactUs';
  static const deactivatePath = '/deactivate';

  final http.Client client;
  final Config config;

  ParticipantUserDatastoreServiceImpl(this.client, this.config);

  @override
  Future<Object> contactUs(String userId, String authToken, String subject,
      String feedbackBody, String email, String firstName) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId, authToken: authToken, contentType: ContentType.json);
    var body = {
      'subject': subject,
      'body': feedbackBody,
      'email': email,
      'firstName': firstName
    };
    var uri = Uri.https(
        config.baseParticipantUrl, '$participantUserDatastore$contactUsPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'contact_us', response, () => CommonResponses.successResponse));
  }

  @override
  Future<Object> deactivate(
      String userId, String authToken, String studyId, String participantId) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId, authToken: authToken, contentType: ContentType.json);
    var body = {
      'studyData': [
        {'studyId': studyId, 'delete': false, 'participantId': participantId}
      ]
    };
    var uri = Uri.https(
        config.baseParticipantUrl, '$participantUserDatastore$deactivatePath');

    return client
        .delete(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'deactivate', response, () => CommonResponses.successResponse));
  }

  @override
  Future<Object> feedback(
      String userId, String authToken, String subject, String feedbackBody) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId, authToken: authToken, contentType: ContentType.json);
    var body = {'subject': subject, 'body': feedbackBody};
    var uri = Uri.https(
        config.baseParticipantUrl, '$participantUserDatastore$feedbackPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'feedback', response, () => CommonResponses.successResponse));
  }

  @override
  Future<Object> getUserProfile(String userId, String authToken) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authToken: authToken);
    var uri = Uri.https(
        config.baseParticipantUrl, '$participantUserDatastore$userProfilePath');

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('user_profile', response,
            () => GetUserProfileResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> register(String emailId, String password) {
    var headers = CommonRequestHeader()
      ..from(config, contentType: ContentType.json);
    var body = {'emailId': emailId, 'password': password};
    var uri = Uri.https(
        config.baseParticipantUrl, '$participantUserDatastore$registerPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse('register',
            response, () => RegistrationResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> resendConfirmation(String userId, String emailId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, contentType: ContentType.json);
    var body = {'emailId': emailId};
    var uri = Uri.https(config.baseParticipantUrl,
        '$participantUserDatastore$resendConfirmationPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'resend_confirmation',
            response,
            () => CommonResponses.successResponse));
  }

  @override
  Future<Object> updateUserProfile(String userId, String authToken,
      GetUserProfileResponse_UserProfile userProfileSettings) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId, authToken: authToken, contentType: ContentType.json);
    var body = {
      'settings': userProfileSettings.toJson(),
      'info': {
        'appVersion': config.version,
        'os': config.platform,
        'deviceToken': ''
      },
      'participantInfo': []
    };
    Uri uri = Uri.https(config.baseParticipantUrl,
        '$participantUserDatastore$updateUserProfilePath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'update_user_profile',
            response,
            () => UpdateUserProfileResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> verifyEmail(
      String emailId, String userId, String verificationCode) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, contentType: ContentType.json);
    var body = {'emailId': emailId, 'code': verificationCode};
    var uri = Uri.https(
        config.baseParticipantUrl, '$participantUserDatastore$verifyEmailPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse('verify_email',
            response, () => VerifyEmailResponse()..fromJson(response.body)));
  }
}
