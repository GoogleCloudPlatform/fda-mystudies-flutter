abstract class AuthenticationService {
  Future<Object> refreshTokenForUser();

  Future<Object> grantVerifiedUser();

  Future<Object> resetPassword(String emailId);

  Future<Object> logout();

  Future<Object> changePassword(String currentPassword, String newPassword);
}
