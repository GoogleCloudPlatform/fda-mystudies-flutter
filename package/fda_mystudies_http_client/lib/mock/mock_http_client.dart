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
    '/auth-server/oauth2/token':
        'lib/mock/scenario/authentication_service/grant_verified_user',
    '/auth-server/user/reset_password':
        'lib/mock/scenario/authentication_service/reset_password',
    '/auth-server/users/userId/logout':
        'lib/mock/scenario/authentication_service/logout',
    '/albums/1': 'lib/mock/scenario/sample_service',
    '/study-datastore/versionInfo':
        'lib/mock/scenario/study_datastore_service/version_info',
    '/study-datastore/studyList':
        'lib/mock/scenario/study_datastore_service/study_list',
    '/study-datastore/activity':
        'lib/mock/scenario/study_datastore_service/activity_steps',
    '/study-datastore/activityList':
        'lib/mock/scenario/study_datastore_service/activity_list',
    '/study-datastore/consentDocument':
        'lib/mock/scenario/study_datastore_service/consent_document',
    '/study-datastore/studyInfo':
        'lib/mock/scenario/study_datastore_service/study_info',
    '/study-datastore/studyDashboard':
        'lib/mock/scenario/study_datastore_service/study_dashboard',
    '/study-datastore/eligibilityConsent':
        'lib/mock/scenario/study_datastore_service/eligibility_and_consent'
  };

  var urlPathToServiceMethod = {
    '/auth-server/users/userId/change_password':
        'authentication_service.change_password',
    '/auth-server/oauth2/token': 'authentication_service.grant_verified_user',
    '/auth-server/user/reset_password': 'authentication_service.reset_password',
    '/auth-server/users/userId/logout': 'authentication_service.logout',
    '/study-datastore/versionInfo': 'study_datastore_service.version_info',
    '/study-datastore/studyList': 'study_datastore_service.study_list',
    '/study-datastore/activity': 'study_datastore_service.activity_steps',
    '/study-datastore/activityList': 'study_datastore_service.activity_list',
    '/study-datastore/consentDocument':
        'study_datastore_service.consent_document',
    '/study-datastore/studyInfo': 'study_datastore_service.study_info',
    '/study-datastore/studyDashboard':
        'study_datastore_service.study_dashboard',
    '/study-datastore/eligibilityConsent':
        'study_datastore_service.eligibility_and_consent'
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

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _mapUrlPathToResponse(url.path);
  }

  Future<http.Response> _mapUrlPathToResponse(String urlPath) {
    var yamlDir = urlPathToMockYamlPath[urlPath];
    var code = config.scenarios[urlPathToServiceMethod[urlPath]] ?? 'default';
    var yamlPath = '';
    if (code.startsWith('common.')) {
      yamlPath = 'lib/mock/scenario/common/${code.split('.').last}.yaml';
    } else {
      yamlPath = '$yamlDir/$code.yaml';
    }
    return _yamlToHttpResponse(yamlPath);
  }

  Future<http.Response> _yamlToHttpResponse(String yamlPath) {
    return File(yamlPath).readAsString().then((content) {
      var doc = loadYaml(content);
      return http.Response(doc['response'], doc['code']);
    });
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
