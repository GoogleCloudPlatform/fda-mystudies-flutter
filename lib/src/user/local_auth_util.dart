import 'package:local_auth/local_auth.dart';

class LocalAuthUtil {
  static final _auth = LocalAuthentication();

  static Future<List<BiometricType>> listBiometricTypes() {
    return _auth.getAvailableBiometrics();
  }
}
