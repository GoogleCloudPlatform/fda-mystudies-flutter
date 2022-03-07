import 'dart:convert';

import 'package:fda_mystudies_spec/authentication_service/change_password.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/logout.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../authentication_service.dart';
import '../session.dart';
import '../util/common_responses.dart';
import '../util/request_header.dart';
import '../util/response_parser.dart';
import '../config.dart';

@Injectable(as: AuthenticationService)
class AuthenticationServiceImpl implements AuthenticationService {
  // Base path
  static const authServer = '/auth-server';

  // Endpoints
  static const signInPath = '/oauth2/auth';
  static const oauth2TokenPath = '/oauth2/token';
  static const resetPasswordPath = '/user/reset_password';
  static const logoutPath = '/logout';
  static const changePasswordPath = '/change_password';

  final http.Client client;
  final Config config;

  AuthenticationServiceImpl(this.client, this.config);

  @override
  Uri getSignInPageURI({String? tempRegId}) {
    Map<String, String> parameters = {
      'source': config.source,
      'client_id': config.hydraClientId, // HYDRA_CLIENT_ID
      'scope': 'offline_access',
      'response_type': 'code',
      'appId': config.appId,
      'appVersion': config.version,
      'mobilePlatform': config.platform,
      'tempRegId': tempRegId ?? '',
      'code_challenge_method': 'S256',
      'code_challenge': Session.shared.codeChallenge,
      'correlationId': Session.shared.correlationId,
      'redirect_uri':
          'https://${config.baseParticipantUrl}$authServer/callback',
      'state': Session.shared.state,
      'appName': config.appName
    };
    return Uri.https(config.baseParticipantUrl, signInPath, parameters);
  }

  @override
  Future<Object> changePassword(
      String userId, String currentPassword, String newPassword) {
    var headers = CommonRequestHeader()..from(config);
    Map<String, String> body = {
      'currentPassword': currentPassword,
      'newPassword': newPassword
    };
    Uri uri = Uri.https(config.baseParticipantUrl,
        '$authServer/users/$userId$changePasswordPath');

    return client
        .put(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse('change_password',
            response, () => ChangePasswordResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> grantVerifiedUser(String userId, String code) {
    var headers = CommonRequestHeader()
      ..from(config, contentType: ContentType.fromUrlEncoded, userId: userId);
    Map<String, String> params = {
      'code': code,
      'grant_type': 'authorization_code',
      'scope': 'openid offline',
      'redirect_uri':
          'https://${config.baseParticipantUrl}$authServer/callback',
      'code_verifier': Session.shared.codeVerifier,
      'userId': userId
    };
    Uri uri = Uri.https(
        config.baseParticipantUrl, '$authServer$oauth2TokenPath', params);

    return client.post(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('grant_verified_user', response, () {
          var refreshTokenResponse = RefreshTokenResponse()
            ..fromJson(response.body);
          _updateSessionProperties(refreshTokenResponse);
          return refreshTokenResponse;
        }));
  }

  @override
  Future<Object> logout(String userId) {
    var headers = CommonRequestHeader()
      ..from(config, authToken: Session.shared.authToken, userId: userId);
    Uri uri = Uri.https(
        config.baseParticipantUrl, '$authServer/users/$userId$logoutPath');

    return client.post(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('logout', response,
            () => LogoutResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> refreshToken(String userId, String authToken) {
    var headers = CommonRequestHeader()
      ..from(config,
          contentType: ContentType.fromUrlEncoded,
          authToken: authToken,
          userId: userId);
    var body = {
      'client_id': config.hydraClientId,
      'grant_type': 'refresh_token',
      'redirect_uri':
          'https://${config.baseParticipantUrl}$authServer/callback',
      'refresh_token': Session.shared.refreshToken,
      'userId': userId
    };
    Uri uri =
        Uri.https(config.baseParticipantUrl, '$authServer$oauth2TokenPath');

    return client
        .post(uri,
            headers: headers.toHeaderJson(),
            body: jsonEncode(body),
            encoding: Encoding.getByName('application/x-www-form-urlencoded'))
        .then((response) =>
            ResponseParser.parseHttpResponse('refresh_token', response, () {
              var refreshTokenResponse = RefreshTokenResponse()
                ..fromJson(response.body);
              _updateSessionProperties(refreshTokenResponse);
              return refreshTokenResponse;
            }));
  }

  @override
  Future<Object> resetPassword(String emailId) {
    var headers = CommonRequestHeader()
      ..from(config, contentType: ContentType.json);
    var body = {'appId': config.appId, 'email': emailId};
    var uri =
        Uri.https(config.baseParticipantUrl, '$authServer$resetPasswordPath');

    return client
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'reset_password', response, () => CommonResponses.successResponse));
  }

  void _updateSessionProperties(RefreshTokenResponse refreshTokenResponse) {
    Session.shared.authToken = _generateAuthToken(refreshTokenResponse);
    Session.shared.refreshToken = refreshTokenResponse.refreshToken;
  }

  String _generateAuthToken(RefreshTokenResponse refreshTokenResponse) {
    String tokenType = refreshTokenResponse.tokenType;
    String accessToken = refreshTokenResponse.accessToken;
    String authToken =
        '${tokenType[0].toUpperCase()}${tokenType.substring(1)} $accessToken';
    return authToken;
  }
}
