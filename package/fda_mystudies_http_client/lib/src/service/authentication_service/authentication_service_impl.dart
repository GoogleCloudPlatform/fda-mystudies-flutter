import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fda_mystudies_spec/authentication_service/change_password.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/logout.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/sign_in.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
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

  Future<String> _fetchLoginChallenge({String? tempRegId}) {
    Map<String, String> parameters = {
      'source': config.source,
      'client_id': config.hydraClientId, // HYDRA_CLIENT_ID
      'scope': 'offline_access openid',
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
    Uri uri = Uri.https(config.baseParticipantUrl, signInPath, parameters);
    return client.get(uri).then((value) {
      String? cookies = value.headers['set-cookie'];
      if (cookies?.isNotEmpty == true) {
        var keyValList = cookies!.split(';');
        Map<String, String> cookieMap = {};
        for (var element in keyValList) {
          var keyValPair = element.split('=');
          if (keyValPair.length == 2) {
            cookieMap[keyValPair[0]] = keyValPair[1];
          }
        }
        return cookieMap['mystudies_login_challenge'] ?? '';
      }
      return '';
    });
  }

  Future<Object> _signInHelper(
      String email, String password, String loginChallenge) {
    if (loginChallenge.isEmpty) {
      return Future.value(CommonErrorResponse.create()
        ..errorDescription = 'Invalid loginChallenge!');
    }
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
    return client.post(uri, headers: headerJson, body: body).then((response) =>
        ResponseParser.parseHttpResponse('sign_in', response, () {
          Map<String, String> headerMap = response.headers;
          var newMap = <String, String?>{};
          if (headerMap['location']?.isNotEmpty == true) {
            newMap['location'] = headerMap['location'];
            final location = Uri.dataFromString(headerMap['location']!);
            var redirectUri = location.queryParameters['redirect_uri'] ?? '';
            if (redirectUri.isNotEmpty) {
              newMap['redirectTo'] = Uri.decodeFull(redirectUri);
            }
          }
          for (var keyValue in headerMap['set-cookie']?.split(';') ?? []) {
            var tokens = keyValue.split('=');
            if (tokens.length == 2) {
              if (tokens[0].contains('mystudies_accountStatus')) {
                newMap['accountStatus'] = tokens[1];
              } else if (tokens[0].contains('mystudies_userId')) {
                newMap['userId'] = tokens[1];
              } else {
                newMap[tokens[0]] = tokens[1];
              }
            }
          }
          //
          // final location = Uri.parse(headerMap['location']!);
          // headerMap['set-cookie'] = cookie;
          // developer.log('LOGIN CHALLENGE: $loginChallenge');
          // headerMap['code'] = loginChallenge;
          // client.get(location, headers: headerMap).then((value) {
          //   developer.log('CALLBACK STATUS CODFE: ${value.statusCode}');
          //   developer.log('CALLBACK BODY: ${jsonEncode(value.body)}');
          //    developer.log('CALLBACK HEADER: ${jsonEncode(value.headers)}');
          // });
          //
          developer.log(
              'STUDY HEADER JSON ENCODED: ${jsonEncode(response.headers)}');
          developer.log('STUDY HEADER TO BE CONVERTED: ${jsonEncode(newMap)}');
          developer.log(
              'STUDY PROTO: ${SignInResponse()..fromJson(jsonEncode(newMap))}');
          return SignInResponse()..fromJson(jsonEncode(newMap));
        }));
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
}
