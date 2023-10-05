import 'package:fda_mystudies_http_proxy/database/db_user.dart';

abstract class UserPreferencesAndCommunicationsJourney {
  // TODO(cg2092): User preference object.
  Future<void> updateUserPreferences(DBUser user);

  DBUser? getUserPreferences();

  // If firstName & email are missing, we record feedback anonymously.
  Future<void> recordFeedback(
      {String feedbackTitle,
      String feedbackContent,
      String? firstName,
      String? email});

  Future<void> deactivateAccountAndWithdrawFromAllStudie();
}
