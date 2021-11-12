import 'package:fda_mystudies_http_client/src/service/util/proto_json.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';

import 'package:flutter_test/flutter_test.dart';

import '../common/common_test_object.dart';

void main() {
  test('convert json string to proto', () {
    var jsonStr = '''
    {
      "code": 200,
      "message": "success"
    }
    ''';
    var proto = CommonTestObject.commonSuccessResponse;

    expect(CommonResponse()..fromJson(jsonStr), proto);
  });
  test('convert proto to map', () {
    var proto = CommonTestObject.commonSuccessResponse;
    var map = {'code': 200, 'message': 'success'};

    expect(proto.toJson(), map);
  });
  test('convert proto to string:string map', () {
    var proto = CommonTestObject.commonSuccessResponse;
    var map = {'code': '200', 'message': 'success'};

    expect(proto.toHeaderJson(), map);
  });
}
