import '../../config/app_config.dart';

class SecureKey {
  static final String isVisitingFirstTime =
      '${AppConfig.shared.currentConfig.appId}.is_visiting_first_time';
  static final String userId =
      '${AppConfig.shared.currentConfig.appId}.user_id';
  static final String authToken =
      '${AppConfig.shared.currentConfig.appId}.auth_token';
  static final String refreshToken =
      '${AppConfig.shared.currentConfig.appId}.refresh_token';
  static final String enrollmentToken =
      '${AppConfig.shared.currentConfig.appId}.enrollment_token';
  static final String fitbitUserId =
      '${AppConfig.shared.currentConfig.appId}.fb_user_id';
  static final String fitbitAccessToken =
      '${AppConfig.shared.currentConfig.appId}.fb_access_token';
  static final String fitbitRefreshToken =
      '${AppConfig.shared.currentConfig.appId}.fb_refresh_token';
}
