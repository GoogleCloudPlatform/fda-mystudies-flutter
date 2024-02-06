import 'model/error_response.dart';

abstract class UserOnboardingJourney {
  Uri getSignInPageUri();

  Future<ErrorResponse?> registerNewUser(
      {required String emailId, required String password});

  Future<ErrorResponse?> verifyEmail({required String verificationCode});

  Future<ErrorResponse?> resendVerificationCode();

  // Q: Only required for demo environment?
  Future<Object> demoSignIn({required String email, required String password});

  Future<ErrorResponse?> reSignIn({bool shouldRefreshToken = false});

  Future<ErrorResponse?> requestHelpForForgottenPassword({required String emailId});

  Future<ErrorResponse?> logout();

  Future<ErrorResponse?> updatePassword(
      {required String currentPassword, required String newPassword});
}
