import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fda_mystudies_spec/authentication_service/change_password.pbserver.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pbserver.dart';
import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../service/authentication_service/authentication_service.dart';
import '../../../service/session.dart';
import '../../../service/util/proto_json.dart';
import '../../../service/util/request_header.dart';
import '../../config.dart';

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
  Uri getSignInPageURI(String? tempRegId) {
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

    Uri changePasswordUri = Uri.https(config.baseParticipantUrl,
        '$authServer/users/$userId$changePasswordPath');

    return client
        .put(changePasswordUri,
            headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) {
      developer.log('CHANGE PASSWORD STATUS CODE : ${response.statusCode}');
      developer.log('CHANGE PASSWORD RESPONSE : ${response.body}');
      try {
        if (response.statusCode == 200) {
          return ChangePasswordResponse()..fromJson(response.body);
        }
        return CommonErrorResponse()..fromJson(response.body);
      } on FormatException {
        return CommonErrorResponse.create()
          ..errorDescription =
              'Invalid json received while making the change_password call!';
      }
    });
  }

  @override
  Future<Object> grantVerifiedUser() {
    // TODO: implement grantVerifiedUser
    throw UnimplementedError();
  }

  @override
  Future<Object> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Object> refreshTokenForUser() {
    // TODO: implement refreshTokenForUser
    throw UnimplementedError();
  }

  @override
  Future<Object> resetPassword(String emailId) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
