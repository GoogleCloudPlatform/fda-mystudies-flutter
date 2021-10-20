abstract class ParticipantUserDatastoreService {
  Future<Object> register();

  Future<Object> verifyEmail();

  Future<Object> resendConfirmation();

  Future<Object> getUserProfile();

  Future<Object> updateUserProfile();

  Future<Object> feedback();

  Future<Object> contactUs();

  Future<Object> deactivate();
}
