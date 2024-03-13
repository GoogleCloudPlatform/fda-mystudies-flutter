import 'dart:convert';

import 'package:fda_mystudies_spec/authentication_service/change_password.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/logout.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/sign_in.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:fitbitter/fitbitter.dart';

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
  Future<http.Response> fireSignInURI({String? tempRegId}) {
    Uri uri = getSignInPageURI(tempRegId: tempRegId);
    return client.get(uri);
  }

  @override
  Future<http.Response> signIn(
      String email, String password, String loginChallenge) {
    var headers = CommonRequestHeader()..from(config);
    Map<String, String> headerJson = headers.toHeaderJson();
    var cookieMap = {
      'mystudies_login_challenge': loginChallenge,
      'mystudies_appId': config.appId,
      'mystudies_correlationId': Session.shared.correlationId,
      'mystudies_appVersion': config.version,
      'mystudies_mobilePlatform': config.platform,
      'mystudies_source': config.source,
      'mystudies_appName': config.appName
    };
    var cookie = '';
    cookieMap.forEach((k, v) {
      cookie += '$k=${Uri.encodeQueryComponent(v)};';
    });
    headerJson['cookie'] = cookie;
    Map<String, String> body = {'email': email, 'password': password};
    Uri uri = Uri.https(config.baseParticipantUrl, '$authServer/login');
    return client.post(uri, headers: headerJson, body: body);
  }

  @override
  Future<Object> demoSignIn(String email, String password,
      {String? tempRegId}) {
    var headers = CommonRequestHeader()..from(config);
    Map<String, String> headerJson = headers.toHeaderJson();
    Map<String, String> body = {'email': email, 'password': password};
    Uri uri = Uri.https(config.baseParticipantUrl, signInPath);
    return client.post(uri, headers: headerJson, body: body).then((response) =>
        ResponseParser.parseHttpResponse('sign_in', response,
            () => SignInResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> changePassword(String authToken, String userId,
      String currentPassword, String newPassword) {
    var headers = CommonRequestHeader()
      ..from(config,
          authToken: authToken, contentType: ContentType.json, userId: userId);
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
  Future<Object> refreshToken(String userId, String authToken,
      {String? refreshToken}) {
    var headers = CommonRequestHeader()
      ..from(config,
          contentType: ContentType.fromUrlEncoded,
          authToken: authToken,
          userId: userId);
    var parameters = {
      'client_id': config.hydraClientId,
      'grant_type': 'refresh_token',
      'redirect_uri':
          'https://${config.baseParticipantUrl}$authServer/callback',
      'refresh_token': refreshToken ?? Session.shared.refreshToken,
      'userId': userId
    };
    Uri uri = Uri.https(
        config.baseParticipantUrl, '$authServer$oauth2TokenPath', parameters);

    return client
        .post(uri,
            headers: headers.toHeaderJson(),
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
    Map<String, String> headerJson = headers.toHeaderJson();
    headerJson.addAll({
      'contactEmail': Session.shared.contactUsEmail,
      'fromEmail': Session.shared.fromEmail,
      'supportEmail': Session.shared.supportEmail
    });
    var body = {
      'appId': config.appId,
      'email': emailId,
      'contactEmail': Session.shared.contactUsEmail,
      'fromEmail': Session.shared.fromEmail,
      'supportEmail': Session.shared.supportEmail
    };
    var uri =
        Uri.https(config.baseParticipantUrl, '$authServer$resetPasswordPath');

    return client.post(uri, headers: headerJson, body: jsonEncode(body)).then(
        (response) => ResponseParser.parseHttpResponse(
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

  @override
  Future<FitbitCredentials?> fitbitSignIn() {
        return FitbitConnector.authorize(
            clientID: config.fitbitClientId,
            clientSecret: config.fitbitClientSecret,
            redirectUri: config.fitbitRedirectUri,
            callbackUrlScheme: config.fitbitCallbackScheme
        );
  }
}
