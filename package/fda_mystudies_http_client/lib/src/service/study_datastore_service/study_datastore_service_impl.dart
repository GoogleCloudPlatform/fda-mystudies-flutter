import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_consent_document.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../util/common_responses.dart';
import '../util/request_header.dart';
import '../util/response_parser.dart';
import '../config.dart';
import '../../../study_datastore_service.dart';

@Injectable(as: StudyDatastoreService)
class StudyDataStoreServiceImpl implements StudyDatastoreService {
  // Base path
  static const studyDatastore = '/study-datastore';

  // Endpoints
  static const versionInfoPath = '/versionInfo';
  static const studyListPath = '/studyList';
  static const fetchActivityStepsPath = '/activity';
  static const getActivityListPath = '/activityList';
  static const getEligibilityAndConsentPath = '/eligibilityConsent';
  static const getStudyInfoPath = '/studyInfo';
  static const getConsentDocumentPath = '/consentDocument';
  static const studyDashboardPath = '/studyDashboard';

  final http.Client client;
  final Config config;

  StudyDataStoreServiceImpl(this.client, this.config);

  @override
  Future<Object> fetchActivitySteps(String studyId, String activityId,
      String activityVersion, String userId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authType: AuthorizationType.basic);
    var params = {
      'studyId': studyId,
      'activityVersion': activityVersion,
      'activityId': activityId
    };
    var uri = Uri.https(config.baseStudiesUrl,
        '$studyDatastore$fetchActivityStepsPath', params);

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('activity_steps', response,
            () => _fetchActivityStepsResponseFromJson(response.body)));
  }

  @override
  Future<Object> getActivityList(String studyId, String userId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authType: AuthorizationType.basic);
    var params = {'studyId': studyId};
    var uri = Uri.https(
        config.baseStudiesUrl, '$studyDatastore$getActivityListPath', params);

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('activity_list', response,
            () => GetActivityListResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> getConsentDocument(String studyId, String userId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authType: AuthorizationType.basic);
    var params = {'studyId': studyId};
    var uri = Uri.https(config.baseStudiesUrl,
        '$studyDatastore$getConsentDocumentPath', params);

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('consent_document', response,
            () => GetConsentDocumentResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> getEligibilityAndConsent(String studyId, String userId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authType: AuthorizationType.basic);
    var params = {'studyId': studyId};
    var uri = Uri.https(config.baseStudiesUrl,
        '$studyDatastore$getEligibilityAndConsentPath', params);

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('eligibility_and_consent', response,
            () => _getEligibilityAndConsentResponseFromJson(response.body)));
  }

  @override
  Future<Object> getStudyDashboard(String studyId) {
    var headers = CommonRequestHeader()
      ..from(config, authType: AuthorizationType.basic);
    var params = {'studyId': studyId};
    var uri = Uri.https(
        config.baseStudiesUrl, '$studyDatastore$studyDashboardPath', params);

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('study_dashboard', response,
            () => GetStudyDashboardResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> getStudyInfo(String studyId, String userId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authType: AuthorizationType.basic);
    var params = {'studyId': studyId};
    var uri = Uri.https(
        config.baseStudiesUrl, '$studyDatastore$getStudyInfoPath', params);

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('study_info', response,
            () => StudyInfoResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> getStudyList(String userId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authType: AuthorizationType.basic);
    var uri = Uri.https(config.baseStudiesUrl, '$studyDatastore$studyListPath');

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse('study_list', response,
            () => GetStudyListResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> getVersionInfo(String userId) {
    var headers = CommonRequestHeader()
      ..from(config, userId: userId, authType: AuthorizationType.basic);
    var uri =
        Uri.https(config.baseStudiesUrl, '$studyDatastore$versionInfoPath');

    return client.get(uri, headers: headers.toHeaderJson()).then((response) =>
        ResponseParser.parseHttpResponse(
            'version_info', response, () => CommonResponses.successResponse));
  }

  FetchActivityStepsResponse _fetchActivityStepsResponseFromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    map['activity']['steps'] = _updateStepValue(map['activity']['steps']);
    return FetchActivityStepsResponse()..fromJson(jsonEncode(map));
  }

  GetEligibilityAndConsentResponse _getEligibilityAndConsentResponseFromJson(
      String json) {
    Map<String, dynamic> map = jsonDecode(json);
    map['eligibility']['test'] = _updateStepValue(map['eligibility']['test']);
    map['eligibility']['correctAnswers'] =
        _updateAnswerList(map['eligibility']['correctAnswers']);
    map['consent']['comprehension']['questions'] =
        _updateStepValue(map['consent']['comprehension']['questions']);
    map['consent']['comprehension']['correctAnswers'] =
        _updateAnswerList(map['consent']['comprehension']['correctAnswers']);
    return GetEligibilityAndConsentResponse()..fromJson(jsonEncode(map));
  }

  List<Map<String, dynamic>> _updateStepValue(List<dynamic> activitySteps) {
    List<Map<String, dynamic>> updatedList = [];
    for (var step in activitySteps) {
      updatedList.add(_updateStepFormat(step));
    }
    return updatedList;
  }

  // TODO(cg2092): add more formats
  Map<String, dynamic> _updateStepFormat(Map<String, dynamic> map) {
    var resultType = map['resultType'];
    var format = map['format'];
    if (resultType == 'scale') {
      map['scaleFormat'] = format;
    } else if (resultType == 'textChoice') {
      map['textChoice'] = format;
    }
    return map;
  }

  List<Map<String, dynamic>> _updateAnswerList(List<dynamic> answers) {
    List<Map<String, dynamic>> updatedList = [];
    for (var ans in answers) {
      updatedList.add(_updateAnswerValue(ans));
    }
    return updatedList;
  }

  // TODO(cg2092): add more formats
  Map<String, dynamic> _updateAnswerValue(Map<String, dynamic> map) {
    var answer = map['answer'];
    if (answer is List) {
      map['textChoiceAnswer'] = answer;
    } else if (answer is bool) {
      map['boolAnswer'] = answer;
    }
    return map;
  }
}
