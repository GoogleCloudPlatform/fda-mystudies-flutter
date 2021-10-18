/// Service for communicating to auth-server
abstract class AuthenticationService {
  Uri getSignInPageURI(String? tempRegId);

  Future<Object> refreshTokenForUser();

  Future<Object> grantVerifiedUser();

  Future<Object> resetPassword(String emailId);

  Future<Object> logout();

  Future<Object> changePassword(String currentPassword, String newPassword);
}
