import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';

void main() {
  test('refresh token response json <-> proto', () {
    var jsonStr =
        '{"access_token":"raiVhD3nakW_ESPzEKojkHzTWUZYk3NvcO0wBKP0OSc.jM3shfjGmagruRCW6vLWij4QZKhXFHwI0I2qPyqhfmg","expires_in":3600,"id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6InB1YmxpYzo3M2IyYmMwZC1iMzM2LTQzMjItYmI4ZS0yMDBjZTc4NGZkYzIiLCJ0eXAiOiJKV1QifQ.eyJhdF9oYXNoIjoiMG9UUm12a0ZCQ0lydnNia2xvSkhOZyIsImF1ZCI6WyJHZkdSOTl1UVRnUFRNOWt6Il0sImF1dGhfdGltZSI6MTYyODQ4OTI1OSwiZXhwIjoxNjMyMzgzMDAzLCJpYXQiOjE2MzIzNzk0MDMsImlzcyI6Imh0dHBzOi8vcGFydGljaXBhbnRzLm1zbW9zYWljLWRlbW8uY2hpbnRhbmdoYXRlLm1lLyIsImp0aSI6ImNmYzlhMWE5LWMzMGItNGY4Mi04MGRjLWJiNTEwOGY4OTIyZSIsIm5vbmNlIjoiIiwicmF0IjoxNjI4NDg5MjM4LCJzaWQiOiJmMzFlNGZmNC02ZDM3LTQ1ZjYtYjJkMi1mNjFlZTZjZTlhYzYiLCJzdWIiOiIxY2E3NjUwYnM5NTQ5MzQ0YWJ4Yjc2ZHQ3MzE0OTJmMmFlZGEifQ.gjw7BYZ_ct1e1m63oHMf0ls-MbuhbU-KdP8XELcxMvVrLnkQjZb1Kx8hj8Ox0C3fe3JCCbxMZvGhvjrRynR_W248rAwl2u5n6bFFW3cpIIW4URNwh-giyQBVVupe3wU7UZ2F2KL8x2b9Rg8tPeISn5Z14QbDwddseyzALui4L1ut1xySE2h-bLxf9CSVOVD5pdk2ej66TPQrrSimd1yu_Gt_gG60O-LlOpsYGyh8w0T9mA3S_aei89WkYcPqfXs9yhGBoMx6yDWped_C79CV13RqsKJ-biwrL9m1vHPFh2OtAdW9n72mi57XLCWk7cmy9r0LSF7FVxPJKG5m-Y_-utUdHdisfr_bBn6XobMGAw1i01RbJSRjJwq5W5fYEePOd1YWpBpqoq4guNZvGK1j8gwcRmbxqU10OCuksNlxrQAo_0JaTEXqk2EnXtgxnx8IV67Bg5HeELXzWimXkCfFas_Cw1W6cEN23sDG6iA4ZZVzzNNmCXJjouI3uFZypURMwVIM81Ph_7t-8lJDcCbqaRWq0Cse5VY3C5Y26L8ZZPIX1MIbQ12bB7_ARKH7WftfiFMVhZodymyPXcDUPWjV05v2AOZWRXpDDd0KZM7ilnHS29axbQ5Y_vQtpGpj6uOCPKLOw-deXQx3KHbOaxK83DQzFDpzEnBNIfK7R5qECw4","refresh_token":"EFhcA6TLU_BQkGV3qUbSO1vhw8s8Vf9cX1jFv-8KVYY.lHSwMbqHh5JQY3L5RTiV3B5TbkbIkCm9yDLOoWR9f6w","scope":"offline_access openid","token_type":"bearer"}';
    var responseFromJson = RefreshTokenResponse.create()
      ..mergeFromProto3Json(jsonDecode(jsonStr));
    var expectedResponse = RefreshTokenResponse()
      ..accessToken =
          'raiVhD3nakW_ESPzEKojkHzTWUZYk3NvcO0wBKP0OSc.jM3shfjGmagruRCW6vLWij4QZKhXFHwI0I2qPyqhfmg'
      ..expiresIn = 3600
      ..idToken =
          'eyJhbGciOiJSUzI1NiIsImtpZCI6InB1YmxpYzo3M2IyYmMwZC1iMzM2LTQzMjItYmI4ZS0yMDBjZTc4NGZkYzIiLCJ0eXAiOiJKV1QifQ.eyJhdF9oYXNoIjoiMG9UUm12a0ZCQ0lydnNia2xvSkhOZyIsImF1ZCI6WyJHZkdSOTl1UVRnUFRNOWt6Il0sImF1dGhfdGltZSI6MTYyODQ4OTI1OSwiZXhwIjoxNjMyMzgzMDAzLCJpYXQiOjE2MzIzNzk0MDMsImlzcyI6Imh0dHBzOi8vcGFydGljaXBhbnRzLm1zbW9zYWljLWRlbW8uY2hpbnRhbmdoYXRlLm1lLyIsImp0aSI6ImNmYzlhMWE5LWMzMGItNGY4Mi04MGRjLWJiNTEwOGY4OTIyZSIsIm5vbmNlIjoiIiwicmF0IjoxNjI4NDg5MjM4LCJzaWQiOiJmMzFlNGZmNC02ZDM3LTQ1ZjYtYjJkMi1mNjFlZTZjZTlhYzYiLCJzdWIiOiIxY2E3NjUwYnM5NTQ5MzQ0YWJ4Yjc2ZHQ3MzE0OTJmMmFlZGEifQ.gjw7BYZ_ct1e1m63oHMf0ls-MbuhbU-KdP8XELcxMvVrLnkQjZb1Kx8hj8Ox0C3fe3JCCbxMZvGhvjrRynR_W248rAwl2u5n6bFFW3cpIIW4URNwh-giyQBVVupe3wU7UZ2F2KL8x2b9Rg8tPeISn5Z14QbDwddseyzALui4L1ut1xySE2h-bLxf9CSVOVD5pdk2ej66TPQrrSimd1yu_Gt_gG60O-LlOpsYGyh8w0T9mA3S_aei89WkYcPqfXs9yhGBoMx6yDWped_C79CV13RqsKJ-biwrL9m1vHPFh2OtAdW9n72mi57XLCWk7cmy9r0LSF7FVxPJKG5m-Y_-utUdHdisfr_bBn6XobMGAw1i01RbJSRjJwq5W5fYEePOd1YWpBpqoq4guNZvGK1j8gwcRmbxqU10OCuksNlxrQAo_0JaTEXqk2EnXtgxnx8IV67Bg5HeELXzWimXkCfFas_Cw1W6cEN23sDG6iA4ZZVzzNNmCXJjouI3uFZypURMwVIM81Ph_7t-8lJDcCbqaRWq0Cse5VY3C5Y26L8ZZPIX1MIbQ12bB7_ARKH7WftfiFMVhZodymyPXcDUPWjV05v2AOZWRXpDDd0KZM7ilnHS29axbQ5Y_vQtpGpj6uOCPKLOw-deXQx3KHbOaxK83DQzFDpzEnBNIfK7R5qECw4'
      ..refreshToken =
          'EFhcA6TLU_BQkGV3qUbSO1vhw8s8Vf9cX1jFv-8KVYY.lHSwMbqHh5JQY3L5RTiV3B5TbkbIkCm9yDLOoWR9f6w'
      ..scope = 'offline_access openid'
      ..tokenType = 'bearer';
    expect(responseFromJson, expectedResponse);
    expect(jsonEncode(expectedResponse.toProto3Json()), jsonStr);
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
