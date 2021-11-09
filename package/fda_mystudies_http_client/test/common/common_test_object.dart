import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pbserver.dart';

class CommonTestObject {
  static var commonSuccessResponse = CommonResponse()
    ..code = 200
    ..message = 'success';

  static var forbiddenError = CommonErrorResponse.create()
    ..status = 403
    ..errorType = 'Forbidden error'
    ..errorCode = '403'
    ..errorDescription = 'Mocked Forbidden error';
}
