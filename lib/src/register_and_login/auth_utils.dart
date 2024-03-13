import 'dart:developer' as developer;

import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../user/user_data.dart';
import 'secure_key.dart';

class AuthUtils {
  static Future<void> saveRefreshTokens(
      RefreshTokenResponse response, String userId) {
    String tokenType = response.tokenType;
    String accessToken = response.accessToken;
    String authToken =
        '${tokenType[0].toUpperCase()}${tokenType.substring(1)} $accessToken';
    String refreshToken = response.refreshToken;
    UserData.shared.authToken = authToken;
    return _saveAuthenticatedUserToDB(authToken, refreshToken, userId);
  }

  static Future<void> _saveAuthenticatedUserToDB(
      String authToken, String refreshToken, String userId) {
    const secureStorage = FlutterSecureStorage(
        iOptions: IOSOptions(),
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    return Future.wait([
      secureStorage.write(key: SecureKey.userId, value: userId),
      secureStorage.write(key: SecureKey.authToken, value: authToken),
      secureStorage.write(key: SecureKey.refreshToken, value: refreshToken)
    ])
        .then((value) => {developer.log('SAVED TO DB')})
        .onError((error, stackTrace) {
      developer.log(error.toString());
      return Future.error(error ?? 'ERROR', stackTrace);
    });
  }

  static Future<void> saveFitbitUserToDB(
      String fitbitAccessToken , String fitbitRefreshToken, String userId) {
    const secureStorage = FlutterSecureStorage(
        iOptions: IOSOptions(),
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    return Future.wait([
      secureStorage.write(key: SecureKey.fitbitUserId, value: userId),
      secureStorage.write(key: SecureKey.fitbitAccessToken, value: fitbitAccessToken),
      secureStorage.write(key: SecureKey.fitbitRefreshToken, value: fitbitRefreshToken)
    ])
        .then((value) => {developer.log('SAVED FITBIT CREDENTIALS TO DB')})
        .onError((error, stackTrace) {
      developer.log(error.toString());
      return Future.error(error ?? 'ERROR', stackTrace);
    });
  }
}
