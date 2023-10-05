abstract class UserOnboardingJourney {
  Uri getSignInPageUri();

  Future<Object> registerNewUser({String emailId, String password});

  Future<Object> verifyEmail({String verificationCode});

  Future<Object> resendVerificationCode();

  Future<Object> signIn({String email, String password});

  Future<Object> reSignIn();

  Future<Object> requestHelpForForgottenPassword();

  Future<Object> logout();

  Future<Object> updatePassword({String currentPassword, String newPassword});
}
