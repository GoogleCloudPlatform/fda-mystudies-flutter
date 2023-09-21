import 'package:realm/realm.dart';

part 'db_user.g.dart';

@RealmModel()
class _DBUser {
  @PrimaryKey()
  String userId = '';
  String emailId = '';

  // Preferences
  bool passcodeEnabled = false;
  bool biometricEnabled = true;
  bool remoteNotificationEnabled = false;
  bool localNotificationEnabled = false;
}
