import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../activity_step_key_id.dart';
import '../../../response_datastore_service.dart';
import '../../database/activity_response_storage_service.dart';
import '../../database/activity_state_storage_service.dart';
import '../../service/session.dart';
import '../../service/util/common_responses.dart';
import '../config.dart';
import '../util/http_client_wrapper.dart';
import '../util/request_header.dart';
import '../util/response_parser.dart';

@Injectable(as: ResponseDatastoreService)
class ResponseDatastoreServiceImpl implements ResponseDatastoreService {
  // Base path
  static const responseDatastore = '/response-datastore';

  // Endpoints
  static const getActivityStatePath = '/participant/get-activity-state';
  static const updateActivityStatePath = '/participant/update-activity-state';
  static const processResponsePath = '/participant/process-response';

  final http.Client client;
  final Config config;
  final ActivityResponseStorageService activityResponseStorageService;
  final ActivityStateStorageService activityStateStorageService;

  ResponseDatastoreServiceImpl(this.client, this.config,
      this.activityResponseStorageService, this.activityStateStorageService);

  @override
  Future<Object> getActivityState(
      String userId, String studyId, String participantId) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId,
          authToken: Session.shared.authToken,
          contentType: ContentType.json);
    var queryParams = {'studyId': studyId, 'participantId': participantId};
    var uri = Uri.https(config.baseParticipantUrl,
        '$responseDatastore$getActivityStatePath', queryParams);

    return HTTPClientWrapper(client)
        .get(uri, headers: headers.toHeaderJson())
        .then((response) => ResponseParser.parseHttpResponse(
            'activity_state',
            response,
            () => GetActivityStateResponse()..fromJson(response.body)));
  }

  @override
  Future<String> getLocalActivityState(
      {required String userId,
      required String studyId,
      required String participantId,
      required String activityId,
      required DateTime date}) {
    return activityStateStorageService.fetch(
        participantId: participantId,
        studyId: studyId,
        activityId: activityId,
        recordedAt: DateTime(date.year, date.month, date.day));
  }

  @override
  Future<Object> processResponse(
      String userId, ActivityResponse activityResponse) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId,
          authToken: Session.shared.authToken,
          contentType: ContentType.json);
    Uri uri = Uri.https(
        config.baseParticipantUrl, '$responseDatastore$processResponsePath');

    var bodyMap = activityResponse.toJson();
    var updatedResults = [];
    List<ActivityResponse_Data_StepResult> results =
        activityResponse.data.results;
    for (var resultObj in results) {
      var result = resultObj.toJson();
      if (result.containsKey('intValue')) {
        result['value'] = result['intValue'];
        result.remove('intValue');
      } else if (result.containsKey('doubleValue')) {
        result['value'] = result['doubleValue'];
        result.remove('doubleValue');
      } else if (result.containsKey('stringValue')) {
        result['value'] = result['stringValue'];
        result.remove('stringValue');
      } else if (result.containsKey('boolValue')) {
        result['value'] = result['boolValue'];
        result.remove('boolValue');
      } else if (result.containsKey('listValue')) {
        result['value'] = result['listValue'];
        result.remove('listValue');
      }
      activityResponseStorageService.upsert(
          participantId: activityResponse.participantId,
          studyId: activityResponse.metadata.studyId,
          activityId: activityResponse.metadata.activityId,
          stepKey: resultObj.key,
          recordedAt: DateTime.parse(resultObj.startTime),
          value: '${result['value']}');

      updatedResults.add(result);
    }
    if (updatedResults.isNotEmpty) {
      bodyMap['data']['results'] = updatedResults;
    }

    return HTTPClientWrapper(client)
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(bodyMap))
        .then((response) => ResponseParser.parseHttpResponse('process_response',
            response, () => CommonResponse()..fromJson(response.body)));
  }

  @override
  Future<Object> updateActivityState(
      String userId,
      String studyId,
      String participantId,
      GetActivityStateResponse_ActivityState activityState) {
    var headers = CommonRequestHeader()
      ..from(config,
          userId: userId,
          authToken: Session.shared.authToken,
          contentType: ContentType.json);
    var body = {
      'studyId': studyId,
      'participantId': participantId,
      'activity': [activityState.toJson()]
    };
    var uri = Uri.https(config.baseParticipantUrl,
        '$responseDatastore$updateActivityStatePath');

    return HTTPClientWrapper(client)
        .post(uri, headers: headers.toHeaderJson(), body: jsonEncode(body))
        .then((response) => ResponseParser.parseHttpResponse(
            'update_activity_state',
            response,
            () => CommonResponses.successResponse));
  }

  @override
  Future<void> updateLocalActivityState(
      {required String userId,
      required String studyId,
      required String participantId,
      required String activityId,
      required String activityState}) {
    final now = DateTime.now();
    return activityStateStorageService.upsert(
        participantId: participantId,
        studyId: studyId,
        activityId: activityId,
        recordedAt: DateTime(now.year, now.month, now.day),
        state: activityState);
  }

  @override
  Future<Object> listResponses(
      {required String userId,
      required String studyId,
      required String participantId,
      required List<ActivityStepKeyId> activityStepKeyIdList}) {
    return Future.wait(activityStepKeyIdList
            .map((activityStepKeyId) => activityResponseStorageService.list(
                participantId: participantId,
                studyId: studyId,
                activityId: activityStepKeyId.activityId,
                stepKey: activityStepKeyId.stepKey))
            .toList())
        .then((value) => value.expand((e) => e).toList());
  }
}
