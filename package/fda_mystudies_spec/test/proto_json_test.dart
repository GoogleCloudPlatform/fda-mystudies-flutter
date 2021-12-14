import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('convert json string to proto', () {
    var jsonStr = '''
    {
      "code": 200,
      "message": "success"
    }
    ''';
    var proto = CommonResponse.create()
      ..code = 200
      ..message = 'success';

    expect(CommonResponse()..fromJson(jsonStr), proto);
  });
  test('convert proto to map', () {
    var proto = CommonResponse.create()
      ..code = 200
      ..message = 'success';
    var map = {'code': 200, 'message': 'success'};

    expect(proto.toJson(), map);
  });
  test('convert proto to string:string map', () {
    var proto = CommonResponse.create()
      ..code = 200
      ..message = 'success';
    var map = {'code': '200', 'message': 'success'};

    expect(proto.toHeaderJson(), map);
  });
}
