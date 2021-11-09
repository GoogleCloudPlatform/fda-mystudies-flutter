/// Service for communicating to auth-server
abstract class AuthenticationService {
  Uri getSignInPageURI({String? tempRegId});

  Future<Object> refreshToken(String userId, String authToken);

  Future<Object> grantVerifiedUser(String userId, String code);

  Future<Object> resetPassword(String emailId);

  Future<Object> logout(String userId, String authToken);

  Future<Object> changePassword(
      String userId, String currentPassword, String newPassword);
}
