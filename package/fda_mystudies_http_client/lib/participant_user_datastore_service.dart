import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/get_user_profile.pb.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/registration.pb.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/update_user_profile.pb.dart';

abstract class ParticipantUserDatastoreService {
  /// Register a new user on the platform.
  ///
  /// [RegistrationResponse] for successful response. Contains userId, unique per user,
  /// and tempRegId to auto-login the user after successful registration.
  /// [CommonErrorResponse] for failed response.
  Future<Object> register(String emailId, String password);

  /// Verify email used while registering the new user via verificationCode sent to the email.
  ///
  /// [VerifyEmailResponse] for successful response. Contains the verifcation verdict &
  /// tempRegId to auto-login the user after successful email verification.
  /// [CommonErrorResponse] for failed response.
  Future<Object> verifyEmail(
      String emailId, String userId, String verificationCode);

  /// Resend the verificationCode to the registered email.
  ///
  /// [CommonResponse] for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> resendConfirmation(String userId, String emailId);

  /// Get user profile and preferences/settings.
  ///
  /// [GetUserProfile] for successful response. Contains data on
  /// user preferences for if touchId or passcode is enabled, and if
  /// local/remote notifications are enabled.
  /// [CommonErrorResponse] for failed response.
  Future<Object> getUserProfile(String userId);

  /// Update user preferences/settings.
  ///
  /// [UpdateUserProfileResponse] for successful user profile update.
  /// [CommonErrorResponse] for failed response.
  Future<Object> updateUserProfile(String userId,
      GetUserProfileResponse_UserProfileSettings userProfileSettings);

  /// Record anonymous user feedback.
  ///
  /// [CommonResponse] for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> feedback(
      String userId, String authToken, String subject, String feedbackBody);

  /// Allow user to contact the study organizaing team.
  ///
  /// [CommonResponse] for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> contactUs(String userId, String authToken, String subject,
      String feedbackBody, String email, String firstName);

  /// Deactivate user account. User will be withdrawn from all the configured
  /// studies on the app.
  ///
  /// [CommonResponse] for successful response.
  /// [CommonErrorResponse] for failed response.
  Future<Object> deactivate(
      String userId, String authToken, String studyId, String participantId);
}
