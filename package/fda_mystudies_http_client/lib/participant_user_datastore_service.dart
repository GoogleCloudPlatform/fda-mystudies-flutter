import 'package:fda_mystudies_spec/participant_user_datastore_service/get_user_profile.pb.dart';

abstract class ParticipantUserDatastoreService {
  Future<Object> register(String emailId, String password);

  Future<Object> verifyEmail(
      String emailId, String userId, String verificationCode);

  Future<Object> resendConfirmation(String userId, String emailId);

  Future<Object> getUserProfile(String userId, String authToken);

  Future<Object> updateUserProfile(String userId, String authToken,
      GetUserProfileResponse_UserProfile userProfileSettings);

  Future<Object> feedback(
      String userId, String authToken, String subject, String feedbackBody);

  Future<Object> contactUs(String userId, String authToken, String subject,
      String feedbackBody, String email, String firstName);

  Future<Object> deactivate(
      String userId, String authToken, String studyId, String participantId);
}
