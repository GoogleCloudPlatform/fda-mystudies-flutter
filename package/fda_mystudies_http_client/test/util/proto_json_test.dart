import 'package:fda_mystudies_http_client/src/service/util/proto_json.dart';
import 'package:fda_mystudies_spec/sample_service/album.pb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('convert json string to proto', () {
    var jsonStr = '''
    {
      "userId": 3,
      "id": 3,
      "title": "test"
    }
    ''';

    var proto = Album.create()
      ..userId = 3
      ..id = 3
      ..title = 'test';

    expect(Album()..fromJson(jsonStr), proto);
  });
  test('convert proto to map', () {
    var proto = Album.create()
      ..userId = 3
      ..id = 3
      ..title = 'test';

    var map = {'userId': 3, 'id': 3, 'title': 'test'};

    expect(proto.toJson(), map);
  });
  test('convert proto to string:string map', () {
    var proto = Album.create()
      ..userId = 3
      ..id = 3
      ..title = 'test';

    var map = {'userId': '3', 'id': '3', 'title': 'test'};

    expect(proto.toHeaderJson(), map);
  });
}
