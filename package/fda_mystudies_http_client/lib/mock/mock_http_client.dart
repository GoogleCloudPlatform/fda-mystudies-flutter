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
        'lib/mock/scenario/study_datastore_service/eligibility_and_consent',
    '/participant-enroll-datastore/studyState':
        'lib/mock/scenario/participant_enroll_datastore_service/study_state',
    '/participant-enroll-datastore/updateStudyState':
        'lib/mock/scenario/participant_enroll_datastore_service/update_study_state',
    '/participant-enroll-datastore/withdrawfromstudy':
        'lib/mock/scenario/participant_enroll_datastore_service/withdraw_from_study',
    '/participant-enroll-datastore/enroll':
        'lib/mock/scenario/participant_enroll_datastore_service/enroll',
    '/participant-enroll-datastore/validateEnrollmentToken':
        'lib/mock/scenario/participant_enroll_datastore_service/validate_enrollment_token',
    '/participant-consent-datastore/consentDocument':
        'lib/mock/scenario/participant_consent_datastore_service/consent_document',
    '/participant-consent-datastore/updateEligibilityConsentStatus':
        'lib/mock/scenario/participant_consent_datastore_service/update_eligibility_consent_status',
    '/response-datastore/participant/get-activity-state':
        'lib/mock/scenario/response_datastore_service/activity_state',
    '/response-datastore/participant/process-response':
        'lib/mock/scenario/response_datastore_service/process_response',
    '/response-datastore/participant/update-activity-state':
        'lib/mock/scenario/response_datastore_service/update_activity_state',
    '/participant-user-datastore/contactUs':
        'lib/mock/scenario/participant_user_datastore_service/contact_us',
    '/participant-user-datastore/deactivate':
        'lib/mock/scenario/participant_user_datastore_service/deactivate',
    '/participant-user-datastore/feedback':
        'lib/mock/scenario/participant_user_datastore_service/feedback',
    '/participant-user-datastore/userProfile':
        'lib/mock/scenario/participant_user_datastore_service/user_profile',
    '/participant-user-datastore/register':
        'lib/mock/scenario/participant_user_datastore_service/register',
    '/participant-user-datastore/resendConfirmation':
        'lib/mock/scenario/participant_user_datastore_service/resend_confirmation',
    '/participant-user-datastore/updateUserProfile':
        'lib/mock/scenario/participant_user_datastore_service/update_user_profile',
    '/participant-user-datastore/verifyEmailId':
        'lib/mock/scenario/participant_user_datastore_service/verify_email'
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
