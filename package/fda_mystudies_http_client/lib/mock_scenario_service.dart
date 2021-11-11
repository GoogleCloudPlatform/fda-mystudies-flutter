/// Service to list out all mocked scenarios available.
abstract class MockScenarioService {
  /// List all mocked services.
  /// Names of directories under `lib/src/mock/scenario`.
  /// Example of item in the list: `authentication_service`.
  Future<List<String>> listServices();

  /// List all mocked methods for the provided service.
  /// Names of directories under `lib/src/mock/scenario/<service>`.
  /// Example of item in the list: `change_password`.
  Future<List<String>> listMethods(String service);

  /// List all scenarios available for the provided method-key.
  /// Names of `yaml` files under `lib/src/mock/scenario/<service>/<method>` without the file extension.
  /// Example of item in the list: `default`.
  Future<List<String>> listScenarios(String service, String method);
}
