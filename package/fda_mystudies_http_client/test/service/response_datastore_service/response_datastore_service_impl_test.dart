import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/response_datastore_service.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../common/common_test_object.dart';

void main() {
  ResponseDatastoreService? responseDatastoreService;
  final config = DemoConfig();

  setUpAll(() {
    configureDependencies(config);
    responseDatastoreService = getIt<ResponseDatastoreService>();
  });

  group('get activity state tests', () {
    test('test default scenario', () async {
      var response = await responseDatastoreService!
          .getActivityState('userId', 'authToken', 'studyId', 'participantId');

      expect(
          response,
          GetActivityStateResponse()
            ..message = 'success'
            ..activities.add(GetActivityStateResponse_ActivityState()
              ..activityId = 'activity_id'
              ..activityRun =
                  (GetActivityStateResponse_ActivityState_ActivityRun()
                    ..completed = 15
                    ..missed = 2
                    ..total = 17)
              ..activityRunId = '18'
              ..activityState = 'in-progress'
              ..activityVersion = '1.1'));
    });
  });

  group('process response tests', () {
    test('test default scenario', () async {
      var response = await responseDatastoreService!
          .processResponse('userId', 'authToken', ActivityResponse());

      expect(response, CommonTestObject.commonSuccessResponse);
    });
  });

  group('update activity status tests', () {
    test('test default scenario', () async {
      var response = await responseDatastoreService!.updateActivityState(
          'userId',
          'authToken',
          'studyId',
          'participantId',
          GetActivityStateResponse_ActivityState());

      expect(response, CommonTestObject.commonSuccessResponse);
    });
  });
}
