import 'dart:io';

import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:fda_mystudies_http_client/src/service/mock_scenario_service/scenario.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

// @Injectable(as: MockScenarioService)
class MockScenarioServiceImpl implements MockScenarioService {
  @override
  Future<List<String>> listMethods(String service) {
    var serviceDir = Directory('lib/src/mock/scenario/$service');
    return listSortedSubDirectories(serviceDir);
  }

  @override
  Future<List<Scenario>> listScenarios(String service, String method) {
    var methodDir = Directory('assets/mock/scenario/$service/$method/');
    var commonDir = Directory('assets/mock/scenario/common/');
    return Future.wait([
      listSortedSubDirectories(methodDir),
      listSortedSubDirectories(commonDir)
    ])
        .then((value) =>
            value[0]
                .map((e) => 'assets/mock/scenario/$service/$method/$e.yaml')
                .toList() +
            value[1].map((e) => 'assets/mock/scenario/common/$e.yaml').toList())
        .then((value) => value.map((e) => scenarioPathToObject(e)).toList())
        .then((value) => Future.wait(value));
  }

  @override
  Future<List<String>> listServices() {
    var scenarioDir = Directory('assets/mock/scenario/');
    return listSortedSubDirectories(scenarioDir).then((value) =>
        value.where((element) => element.endsWith('service')).toList());
  }

  Future<List<String>> listSortedSubDirectories(Directory dir) {
    if (!dir.existsSync()) {
      return Future.value([]);
    }
    return dir.list().toList().then((list) => list
        .map((serviceDir) => p.basenameWithoutExtension(serviceDir.path))
        .toList()
      ..sort());
  }

  Future<Scenario> scenarioPathToObject(String path) {
    return rootBundle.loadString(path).then((content) {
      var doc = loadYaml(content);
      return Scenario(
          title: doc['title'],
          description: doc['description'],
          response: http.Response(doc['response'], doc['code']),
          scenarioCode: pathToScenarioCode(path));
    });
  }

  String pathToScenarioCode(String path) {
    if (p.split(path).contains('common')) {
      return 'common.${p.basenameWithoutExtension(path)}';
    }
    return p.basenameWithoutExtension(path);
  }
}
