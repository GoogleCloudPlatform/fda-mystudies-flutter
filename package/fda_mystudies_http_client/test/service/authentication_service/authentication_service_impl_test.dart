import 'package:fda_mystudies_http_client/injection/injection.dart';
import 'package:fda_mystudies_http_client/mock/demo_config.dart';
import 'package:fda_mystudies_http_client/service/authentication_service/authentication_service.dart';
import 'package:fda_mystudies_spec/authentication_service/change_password.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('change password tests', () {
    AuthenticationService? authenticationService;
    final config = DemoConfig();

    setUpAll(() {
      configureDependencies(config);
      authenticationService = getIt<AuthenticationService>();
    });

    test('test default scenario', () async {
      config.serviceMethodScenarioMap = {
        "authentication_service.change_password": "default"
      };
      var response = await authenticationService!
          .changePassword('userId', 'current', 'new');
      expect(
          response,
          ChangePasswordResponse.create()
            ..status = 200
            ..code = '200'
            ..message = 'success');
    });

    test('test invalid_json scenario', () async {
      config.serviceMethodScenarioMap = {
        "authentication_service.change_password": "invalid_json"
      };
      var response = await authenticationService!
          .changePassword('userId', 'current', 'new');
      expect(
          response,
          CommonErrorResponse.create()
            ..errorDescription =
                'Invalid json received while making the change_password call!');
    });
  });
}
