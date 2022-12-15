import 'package:http/http.dart' as http;

import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/change_password.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';

/// Service for communicating to auth-server
abstract class AuthenticationService {
  /// Returns OAuth SignIn page URI.
  Uri getSignInPageURI({String? tempRegId});

  /// Fire SignInPageURI request.
  Future<http.Response> fireSignInURI({String? tempRegId});

  /// Perform SignIn
  Future<http.Response> signIn(
      String email, String password, String loginChallenge);

  /// Return new access token. To be used while auto-signin.
  ///
  /// [RefreshTokenResponse] for successful response, contains new refresh and access token.
  /// [CommonErrorResponse] for failed response.
  Future<Object> refreshToken(String userId, String authToken);

  /// Return new access token. To be used while new-sign.
  ///
  /// [RefreshTokenResponse] for successful response, contains new refresh and access token.
  /// [CommonErrorResponse] for failed response.
  Future<Object> grantVerifiedUser(String userId, String code);

  /// [CommonResponse] for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> resetPassword(String emailId);

  Future<Object> logout(String userId);

  /// [ChangePasswordResponse] for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> changePassword(
      String userId, String currentPassword, String newPassword);
}
