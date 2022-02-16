import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

import '../service/config.dart';

class MockHttpClient implements http.Client {
  final Config config;

  MockHttpClient(this.config);

  var urlPathToMockYamlPath = {
    '/auth-server/users/userId/change_password':
        'assets/mock/scenario/authentication_service/change_password',
    '/auth-server/oauth2/token':
        'assets/mock/scenario/authentication_service/grant_verified_user',
    '/auth-server/user/reset_password':
        'assets/mock/scenario/authentication_service/reset_password',
    '/auth-server/users/userId/logout':
        'assets/mock/scenario/authentication_service/logout',
    '/albums/1': 'assets/mock/scenario/sample_service',
    '/study-datastore/versionInfo':
        'assets/mock/scenario/study_datastore_service/version_info',
    '/study-datastore/studyList':
        'assets/mock/scenario/study_datastore_service/study_list',
    '/study-datastore/activity':
        'assets/mock/scenario/study_datastore_service/activity_steps',
    '/study-datastore/activityList':
        'assets/mock/scenario/study_datastore_service/activity_list',
    '/study-datastore/consentDocument':
        'assets/mock/scenario/study_datastore_service/consent_document',
    '/study-datastore/studyInfo':
        'assets/mock/scenario/study_datastore_service/study_info',
    '/study-datastore/studyDashboard':
        'assets/mock/scenario/study_datastore_service/study_dashboard',
    '/study-datastore/eligibilityConsent':
        'assets/mock/scenario/study_datastore_service/eligibility_and_consent',
    '/participant-enroll-datastore/studyState':
        'assets/mock/scenario/participant_enroll_datastore_service/study_state',
    '/participant-enroll-datastore/updateStudyState':
        'assets/mock/scenario/participant_enroll_datastore_service/update_study_state',
    '/participant-enroll-datastore/withdrawfromstudy':
        'assets/mock/scenario/participant_enroll_datastore_service/withdraw_from_study',
    '/participant-enroll-datastore/enroll':
        'assets/mock/scenario/participant_enroll_datastore_service/enroll',
    '/participant-enroll-datastore/validateEnrollmentToken':
        'assets/mock/scenario/participant_enroll_datastore_service/validate_enrollment_token',
    '/participant-consent-datastore/consentDocument':
        'assets/mock/scenario/participant_consent_datastore_service/consent_document',
    '/participant-consent-datastore/updateEligibilityConsentStatus':
        'assets/mock/scenario/participant_consent_datastore_service/update_eligibility_consent_status',
    '/response-datastore/participant/get-activity-state':
        'assets/mock/scenario/response_datastore_service/activity_state',
    '/response-datastore/participant/process-response':
        'assets/mock/scenario/response_datastore_service/process_response',
    '/response-datastore/participant/update-activity-state':
        'assets/mock/scenario/response_datastore_service/update_activity_state',
    '/participant-user-datastore/contactUs':
        'assets/mock/scenario/participant_user_datastore_service/contact_us',
    '/participant-user-datastore/deactivate':
        'assets/mock/scenario/participant_user_datastore_service/deactivate',
    '/participant-user-datastore/feedback':
        'assets/mock/scenario/participant_user_datastore_service/feedback',
    '/participant-user-datastore/userProfile':
        'assets/mock/scenario/participant_user_datastore_service/user_profile',
    '/participant-user-datastore/register':
        'assets/mock/scenario/participant_user_datastore_service/register',
    '/participant-user-datastore/resendConfirmation':
        'assets/mock/scenario/participant_user_datastore_service/resend_confirmation',
    '/participant-user-datastore/updateUserProfile':
        'assets/mock/scenario/participant_user_datastore_service/update_user_profile',
    '/participant-user-datastore/verifyEmailId':
        'assets/mock/scenario/participant_user_datastore_service/verify_email'
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
        'study_datastore_service.eligibility_and_consent',
    '/participant-enroll-datastore/studyState':
        'participant_enroll_datastore_service.study_state',
    '/participant-enroll-datastore/updateStudyState':
        'participant_enroll_datastore_service.update_study_state',
    '/participant-enroll-datastore/withdrawfromstudy':
        'participant_enroll_datastore_service.withdraw_from_study',
    '/participant-enroll-datastore/enroll':
        'participant_enroll_datastore_service.enroll',
    '/participant-enroll-datastore/validateEnrollmentToken':
        'participant_enroll_datastore_service.validate_enrollment_token',
    '/participant-consent-datastore/consentDocument':
        'participant_consent_datastore_service.consent_document',
    '/participant-consent-datastore/updateEligibilityConsentStatus':
        'participant_consent_datastore_service.update_eligibility_consent_status',
    '/response-datastore/participant/get-activity-state':
        'response_datastore_service.activity_state',
    '/response-datastore/participant/process-response':
        'response_datastore_service.process_response',
    '/response-datastore/participant/update-activity-state':
        'response_datastore_service.update_activity_state',
    '/participant-user-datastore/contactUs':
        'participant_user_datastore_service.contact_us',
    '/participant-user-datastore/deactivate':
        'participant_user_datastore_service.deactivate',
    '/participant-user-datastore/feedback':
        'participant_user_datastore_service.feedback',
    '/participant-user-datastore/userProfile':
        'participant_user_datastore_service.user_profile',
    '/participant-user-datastore/register':
        'participant_user_datastore_service.register',
    '/participant-user-datastore/resendConfirmation':
        'participant_user_datastore_service.resend_confirmation',
    '/participant-user-datastore/updateUserProfile':
        'participant_user_datastore_service.update_user_profile',
    '/participant-user-datastore/verifyEmailId':
        'participant_user_datastore_service.verify_email'
  };

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    if (url.path == '/study-datastore/activity') {
      return _mapUrlToActivityStepsResponse(url);
    }
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

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _mapUrlPathToResponse(url.path);
  }

  Future<http.Response> _mapUrlPathToResponse(String urlPath) {
    var yamlDir = urlPathToMockYamlPath[urlPath];
    var code = config.scenarios[urlPathToServiceMethod[urlPath]] ?? 'default';
    var yamlPath = '';
    if (code.startsWith('common.')) {
      yamlPath = 'assets/mock/scenario/common/${code.split('.').last}.yaml';
    } else {
      yamlPath = '$yamlDir/$code.yaml';
    }
    return _yamlToHttpResponse(yamlPath);
  }

  Future<http.Response> _mapUrlToActivityStepsResponse(Uri url) {
    var yamlDir = urlPathToMockYamlPath[url.path];
    var activityId = url.queryParameters['activityId'] ?? 'default';
    var code = config.scenarios[urlPathToServiceMethod[url.path]];
    if (code == null && activityId != null) {
      code = activityId;
    } else {
      code = 'default';
    }
    var yamlPath = '';
    if (code.startsWith('common.')) {
      yamlPath = 'assets/mock/scenario/common/${code.split('.').last}.yaml';
    } else {
      yamlPath = '$yamlDir/$code.yaml';
    }
    return _yamlToHttpResponse(yamlPath);
  }

  Future<http.Response> _yamlToHttpResponse(String yamlPath) {
    return rootBundle
        .loadString('packages/fda_mystudies_http_client/$yamlPath')
        .then((content) {
      var doc = loadYaml(content);
      return http.Response(doc['response'], doc['code']);
    });
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
