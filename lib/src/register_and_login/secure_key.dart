import 'package:fda_mystudies/main.dart';

class SecureKey {
  static final String userId = '${curConfig.appId}.user_id';
  static final String authToken = '${curConfig.appId}.auth_token';
  static final String refreshToken = '${curConfig.appId}.refresh_token';
  static final String enrollmentToken = '${curConfig.appId}.enrollment_token';
}
