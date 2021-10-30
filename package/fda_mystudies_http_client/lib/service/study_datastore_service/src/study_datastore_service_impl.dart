import 'dart:convert';

import 'package:fda_mystudies_http_client/service/util/proto_json.dart';
import 'package:fda_mystudies_http_client/service/util/response_parser.dart';
import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pbserver.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_consent_document.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pbserver.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../service/util/request_header.dart';
import '../../config.dart';
import '../study_datastore_service.dart';

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
            () => GetEligibilityAndConsentResponse()..fromJson(response.body)));
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

    return client
        .get(uri, headers: headers.toHeaderJson())
        .then((response) => ResponseParser.parseHttpResponse(
            'version_info',
            response,
            () => CommonResponse.create()
              ..code = 200
              ..message = 'success'));
  }

  FetchActivityStepsResponse _fetchActivityStepsResponseFromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    map['activity']['steps'] = _updateStepValue(map['activity']['steps']);
    return FetchActivityStepsResponse()..fromJson(jsonEncode(map));
  }

  List<Map<String, dynamic>> _updateStepValue(List<dynamic> activityStepList) {
    List<Map<String, dynamic>> updatedList = [];
    for (var val in activityStepList) {
      updatedList.add(_activityFromJson(val));
    }
    return updatedList;
  }

  // TODO(cg2092): add more formats
  Map<String, dynamic> _activityFromJson(Map<String, dynamic> map) {
    if (map['resultType'] == 'scale') {
      map['scaleFormat'] = map['format'];
    }
    return map;
  }
}
