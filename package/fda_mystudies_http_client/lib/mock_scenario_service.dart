import 'src/service/mock_scenario_service/scenario.dart';

/// Service to list out all mocked scenarios available.
abstract class MockScenarioService {
  /// List all mocked services.
  /// Names of directories under `assets/mock/scenario`.
  /// Example of item in the list: `authentication_service`.
  Future<List<String>> listServices();

  /// List all mocked methods for the provided service.
  /// Names of directories under `assets/mock/scenario/<service>`.
  /// Example of item in the list: `change_password`.
  Future<List<String>> listMethods(String service);

  /// List all scenarios available for the provided method-key.
  /// Names of `yaml` files under `assets/mock/scenario/<service>/<method>` without the file extension.
  /// Example of item in the list: `default`.
  Future<List<Scenario>> listScenarios(String service, String method);
}
