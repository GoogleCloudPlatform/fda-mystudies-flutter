import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

import '../service/config.dart';

class MockHttpClient implements http.Client {
  final Config config;

  MockHttpClient(this.config);

  var urlPathToMockYamlPath = {
    '/auth-server/users/userId/change_password':
        'lib/mock/scenario/authentication_service/change_password',
    '/albums/1': 'lib/mock/scenario/sample_service'
  };

  var urlPathToServiceMethod = {
    '/auth-server/users/userId/change_password':
        'authentication_service.change_password'
  };

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _mapUrlPathToResponse(url.path);
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _mapUrlPathToResponse(url.path);
  }

  Future<http.Response> _mapUrlPathToResponse(String urlPath) {
    var yamlDir = urlPathToMockYamlPath[urlPath];
    var yamlFile =
        config.scenarios[urlPathToServiceMethod[urlPath]] ?? 'default';
    var yamlPath = '$yamlDir/$yamlFile.yaml';
    return _yamlToHttpResponse(yamlPath);
  }

  Future<http.Response> _yamlToHttpResponse(String yamlPath) {
    return File(yamlPath).readAsString().then((content) {
      var doc = loadYaml(content);
      return http.Response(doc['response'], doc['code']);
    });
  }

  @override
  // method to ignore overriding unnecessary methods.
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
