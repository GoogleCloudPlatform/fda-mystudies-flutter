import 'dart:developer' as developer;

import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:http/http.dart' as http;

class ResponseParser {
  static Object parseHttpResponse(String apiName, http.Response response,
      Object Function() successResponse) {
    developer
        .log('${apiName.toUpperCase()} STATUS CODE : ${response.statusCode}');
    developer.log('${apiName.toUpperCase()} RESPONSE : ${response.body}');
    developer.log('${apiName.toUpperCase()} HEADERS : ${response.headers}');
    try {
      if (response.statusCode == 200) {
        return successResponse();
      } else if (apiName == 'register' && response.statusCode == 201) {
        return successResponse();
      } else if (apiName == 'sign_in') {
        if (response.statusCode == 200 &&
            response.body.contains(
                'Wrong email or password. Try again or click Forgot Password')) {
          return CommonErrorResponse.create()
            ..errorDescription =
                'Wrong email or password. Try again or click Forgot Password!';
        } else if (response.statusCode == 302) {
          return successResponse();
        }
      }
      return CommonErrorResponse()..fromJson(response.body);
    } on FormatException {
      return CommonErrorResponse.create()
        ..errorDescription =
            'Invalid json received while making the $apiName call!';
    }
  }
}
