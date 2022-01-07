import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MockScenarioService? mockScenarioService;
  final config = DemoConfig();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    configureDependencies(config);
    mockScenarioService = getIt<MockScenarioService>();
  });

  test('test list services', () async {
    var response = await mockScenarioService!.listServices();

    expect(response, [
      'authentication_service',
      'participant_consent_datastore_service',
      'participant_enroll_datastore_service',
      'participant_user_datastore_service',
      'response_datastore_service',
      'study_datastore_service'
    ]);
  });

  test('test list methods', () async {
    var response =
        await mockScenarioService!.listMethods('authentication_service');

    expect(response,
        ['change_password', 'grant_verified_user', 'logout', 'reset_password']);
  });

  test('test list scenarios', () async {
    var response = await mockScenarioService!
        .listScenarios('authentication_service', 'change_password');

    expect(response.map((e) => e.scenarioCode), [
      'default',
      'common.common_error',
      'common.internal_server_error',
      'common.invalid_json',
      'common.unauthorized_error'
    ]);
  });
}
