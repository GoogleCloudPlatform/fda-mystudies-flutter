import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';

class CommonTestObject {
  static var forbiddenError = CommonErrorResponse.create()
    ..status = 403
    ..errorType = 'Forbidden error'
    ..errorCode = '403'
    ..errorDescription = 'Mocked Forbidden error';
}
