import 'dart:io';

import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;

@Injectable(as: MockScenarioService)
class MockScenarioServiceImpl implements MockScenarioService {
  @override
  Future<List<String>> listMethods(String service) {
    var serviceDir = Directory('lib/src/mock/scenario/$service');
    return listSortedSubDirectories(serviceDir);
  }

  @override
  Future<List<String>> listScenarios(String service, String method) {
    var methodDir = Directory('lib/src/mock/scenario/$service/$method');
    var commonDir = Directory('lib/src/mock/scenario/common');
    var commonScenarios = listSortedSubDirectories(commonDir)
        .then((value) => value.map((e) => 'common.$e').toList());
    return Future.wait([listSortedSubDirectories(methodDir), commonScenarios])
        .then((value) {
      var methodSpecificScenarios = value[0];
      var commonScenarios = value[1];
      methodSpecificScenarios.addAll(commonScenarios);
      return methodSpecificScenarios;
    });
  }

  @override
  Future<List<String>> listServices() {
    var scenarioDir = Directory('lib/src/mock/scenario');
    return listSortedSubDirectories(scenarioDir).then((value) =>
        value.where((element) => element.endsWith('service')).toList());
  }

  Future<List<String>> listSortedSubDirectories(Directory dir) {
    if (!dir.existsSync()) {
      return Future.value([]);
    }
    return dir.list().toList().then((list) => list
        .map((serviceDir) => p.basename(p.withoutExtension(serviceDir.path)))
        .toList()
      ..sort());
  }
}
