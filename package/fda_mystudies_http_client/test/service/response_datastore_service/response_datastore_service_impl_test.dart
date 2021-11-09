import 'package:fda_mystudies_http_client/injection/injection.dart';
import 'package:fda_mystudies_http_client/mock/demo_config.dart';
import 'package:fda_mystudies_http_client/service/response_datastore_service/response_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pbserver.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pbserver.dart';
import 'package:flutter_test/flutter_test.dart';

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

      expect(
          response,
          CommonResponse.create()
            ..code = 200
            ..message = 'success');
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

      expect(
          response,
          CommonResponse.create()
            ..code = 200
            ..message = 'success');
    });
  });
}
