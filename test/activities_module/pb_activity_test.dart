import 'package:clock/clock.dart';
import 'package:fda_mystudies/src/activities_module/pb_activity.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var dayBeforeStart = DateTime(2021, 5, 5);
  var dayAfterEnd = DateTime(2022, 5, 7);
  var firstDay = DateTime(2021, 5, 6);

  var activityId = 'activity-id';
  var activityData = GetActivityListResponse_Activity.create()
    ..startTime = '2021-05-06T07:00:00.000+0000'
    ..endTime = '2022-05-06T07:00:00.000+0000';
  var activityStateData = GetActivityStateResponse_ActivityState.create()
    ..activityRunId = '1'
    ..activityRun = (GetActivityStateResponse_ActivityState_ActivityRun.create()
      ..completed = 0
      ..missed = 0
      ..total = 365);
  var activity = PbActivity(activityId, activityData, activityStateData);

  test('Test PbActivity status', () {
    withClock(Clock.fixed(dayBeforeStart), () {
      expect(activity.status, PbActivityStatus.upcoming);
    });
    withClock(Clock.fixed(dayAfterEnd), () {
      expect(activity.status, PbActivityStatus.ended);
    });
    withClock(Clock.fixed(firstDay), () {
      expect(activity.status, PbActivityStatus.start);
    });
    withClock(Clock.fixed(firstDay), () {
      var completedActivity = PbActivity(
          activityId,
          activityData,
          activityStateData
            ..activityState = 'completed'
            ..activityRun =
                (GetActivityStateResponse_ActivityState_ActivityRun.create()
                  ..completed = 1
                  ..missed = 0
                  ..total = 365));
      expect(completedActivity.status, PbActivityStatus.completed);
    });
    withClock(Clock.fixed(firstDay), () {
      var missedActivity = PbActivity(
          activityId,
          activityData,
          activityStateData
            ..activityState = 'in-progress'
            ..activityRun =
                (GetActivityStateResponse_ActivityState_ActivityRun.create()
                  ..completed = 0
                  ..missed = 1
                  ..total = 365));
      expect(missedActivity.status, PbActivityStatus.missed);
    });
    withClock(Clock.fixed(firstDay), () {
      var inProgressActivity = PbActivity(
          activityId,
          activityData,
          activityStateData
            ..activityState = 'inProgress'
            ..activityRun =
                (GetActivityStateResponse_ActivityState_ActivityRun.create()
                  ..completed = 0
                  ..missed = 0
                  ..total = 365));
      expect(inProgressActivity.status, PbActivityStatus.inPorgress);
    });
  });
}
