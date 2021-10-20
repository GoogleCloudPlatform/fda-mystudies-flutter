import 'package:fda_mystudies_http_client/service/config.dart';
import 'package:fda_mystudies_http_client/service/sample_service/sample_service.dart';
import 'package:fda_mystudies_http_client/injection/environment.dart';
import 'package:fda_mystudies_http_client/injection/injection.dart';
import 'package:fda_mystudies_spec/sample_service/album.pbserver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/src/injectable_annotations.dart' as injectable;

void main() {
  setUpAll(() => configureDependencies(_LiveConfig()));
  group('tests in live environment', () {
    test('make http call and parse response to dart object', () async {
      final sampleService = getIt<SampleService>();
      final album = await sampleService.makeCall();
      expect(
          album,
          Album.create()
            ..userId = 1
            ..id = 1
            ..title = 'quidem molestiae enim');
    });
  });
}

class _LiveConfig implements Config {
  @override
  injectable.Environment get environment => live;

  @override
  // This is done to avoid setting unnecessary values for live config demo.
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
