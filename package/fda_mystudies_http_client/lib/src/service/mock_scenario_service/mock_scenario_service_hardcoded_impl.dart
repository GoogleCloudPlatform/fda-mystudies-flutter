import 'dart:io';

import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:fda_mystudies_http_client/src/service/mock_scenario_service/scenario.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

// TODO (cg2092): Replace hardcoded values by directory listing code when it starts working.
@Injectable(as: MockScenarioService)
class MockScenarioServiceHardcodedImpl implements MockScenarioService {
  @override
  Future<List<String>> listMethods(String service) {
    var serviceMethodMap = {
      'authentication_service': [
        'login',
        'sign_in',
        'change_password',
        'grant_verified_user',
        'logout',
        'reset_password'
      ],
      'participant_consent_datastore_service': [
        'consent_document',
        'update_eligibility_consent_status'
      ],
      'participant_enroll_datastore_service': [
        'enroll',
        'study_state',
        'update_study_state',
        'validate_enrollment_token',
        'withdraw_from_study'
      ],
      'participant_user_datastore_service': [
        'app_info',
        'contact_us',
        'deactivate',
        'feedback',
        'register',
        'resend_confirmation',
        'update_user_profile',
        'user_profile',
        'verify_email'
      ],
      'response_datastore_service': [
        'activity_state',
        'process_response',
        'update_activity_state'
      ],
      'study_datastore_service': [
        'activity_list',
        'activity_steps',
        'consent_document',
        'eligibility_and_consent',
        'study_dashboard',
        'study_info',
        'study_list',
        'version_info'
      ]
    };
    return Future.value(serviceMethodMap[service]);
  }

  @override
  Future<List<Scenario>> listScenarios(String service, String method) {
    var commonDirPath =
        'packages/fda_mystudies_http_client/assets/mock/scenario/common/';
    var commonScenarios = [
      'common_error',
      'internal_server_error',
      'invalid_json',
      'unauthorized_error'
    ].map((e) => scenarioPathToObject('$commonDirPath$e.yaml')).toList();

    var specificDirPath =
        'packages/fda_mystudies_http_client/assets/mock/scenario/$service/$method/';
    var specificScenarios = ['default']
        .map((e) => scenarioPathToObject('$specificDirPath$e.yaml'))
        .toList();

    return Future.wait(specificScenarios + commonScenarios);
  }

  @override
  Future<List<String>> listServices() {
    return Future.value([
      'authentication_service',
      'participant_consent_datastore_service',
      'participant_enroll_datastore_service',
      'participant_user_datastore_service',
      'response_datastore_service',
      'study_datastore_service'
    ]);
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
