import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fda_mystudies_spec/participant_user_datastore_service/app_info.pb.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';

void main() {
  test('refresh token response json <-> proto', () {
    var jsonStr =
        '{"access_token":"sample_token","expires_in":3600,"id_token":"id_token.token","refresh_token":"refresh_token.token","scope":"offline_access openid","token_type":"bearer"}';
    var responseFromJson = RefreshTokenResponse.create()
      ..mergeFromProto3Json(jsonDecode(jsonStr));
    var expectedResponse = RefreshTokenResponse()
      ..accessToken = 'sample_token'
      ..expiresIn = 3600
      ..idToken = 'id_token.token'
      ..refreshToken = 'refresh_token.token'
      ..scope = 'offline_access openid'
      ..tokenType = 'bearer';
    expect(responseFromJson, expectedResponse);
    expect(jsonEncode(expectedResponse.toProto3Json()), jsonStr);
  });

  test('app info response json <-> proto', () {
    var jsonStr = '''
    {
      "status" : 200,
      "fromEmail" : "abc@test.com",
      "appName" : "FDA MyStudies",
      "privacyPolicyUrl" : "https:\/\/abc.xyz\/privacy",
      "code" : "code",
      "contactUsEmail" : "abc@test.com",
      "termsUrl" : "https:\/\/abc.xyz\/terms",
      "appWebsite" : "https:\/\/abc.xyz\/",
      "supportEmail" : "abc@test.com",
      "version" : {
        "android" : {
          "latestVersion" : "1",
          "forceUpdate" : "false"
        },
        "ios" : {
          "latestVersion" : "1.0.1",
          "forceUpdate" : "false"
        }
      },
      "message" : "App fetched successfully"
    }
    ''';
    var responseFromJson = AppInfoResponse.create()
      ..mergeFromProto3Json(jsonDecode(jsonStr));
    var expectedResponse = AppInfoResponse()
      ..status = 200
      ..fromEmail = "abc@test.com"
      ..appName = "FDA MyStudies"
      ..privacyPolicyUrl = "https://abc.xyz/privacy"
      ..code = "code"
      ..contactUsEmail = "abc@test.com"
      ..termsUrl = "https://abc.xyz/terms"
      ..appWebsite = "https://abc.xyz/"
      ..supportEmail = "abc@test.com"
      ..version = (AppInfoResponse_Version()
        ..ios = (AppInfoResponse_Version_PlatformInfo()
          ..latestVersion = "1.0.1"
          ..forceUpdate = "false")
        ..android = (AppInfoResponse_Version_PlatformInfo()
          ..latestVersion = "1"
          ..forceUpdate = "false"))
      ..message = "App fetched successfully";
    expect(responseFromJson, expectedResponse);
  });

  test('common error response json <-> proto', () {
    var jsonStr =
        '{"status":500,"error_type":"500 INTERNAL_SERVER_ERROR","error_code":"EC_0009","error_description":"Sorry, an error has occurred and your request could not be processed. Please try again later.","timestamp":"1633597499252","violations":[{"path":"path","message":"message"}]}';
    var responseFromJson = CommonErrorResponse.create()
      ..mergeFromProto3Json(jsonDecode(jsonStr));
    var expectedResponse = CommonErrorResponse()
      ..status = 500
      ..errorType = "500 INTERNAL_SERVER_ERROR"
      ..errorCode = "EC_0009"
      ..errorDescription =
          "Sorry, an error has occurred and your request could not be processed. Please try again later."
      ..timestamp = Int64.parseInt('1633597499252')
      ..violations.add(CommonErrorResponse_CommonErrorViolation.create()
        ..path = "path"
        ..message = "message");
    expect(responseFromJson, expectedResponse);
    expect(jsonEncode(expectedResponse.toProto3Json()), jsonStr);
  });
}
