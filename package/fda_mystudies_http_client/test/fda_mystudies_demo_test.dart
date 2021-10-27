import 'package:fda_mystudies_http_client/mock/demo_config.dart';
import 'package:fda_mystudies_http_client/service/sample_service/sample_service.dart';
import 'package:fda_mystudies_http_client/injection/injection.dart';
import 'package:fda_mystudies_http_client/service/util/proto_json.dart';
import 'package:fda_mystudies_spec/sample_service/album.pbserver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => configureDependencies(DemoConfig()));
  group('tests in demo environment', () {
    test('make http call and parse response to dart object', () async {
      final sampleService = getIt<SampleService>();
      final album = await sampleService.makeCall();
      expect(
          album,
          Album.create()
            ..userId = 3
            ..id = 3
            ..title = 'test');

      expect(album.toJson(), {'userId': 3, 'id': 3, 'title': 'test'});
    });
  });
}
