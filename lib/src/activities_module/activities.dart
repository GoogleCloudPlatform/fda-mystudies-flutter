import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/response_datastore_service.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/future_loading_page.dart';
import '../common/widget_util.dart';
import '../user/user_data.dart';
import 'cupertino_activity_response_processor.dart';
import 'cupertino_activity_tile.dart';
import 'material_activity_response_processor.dart';
import 'material_activity_tile.dart';
import 'pb_activity.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage.build(context,
        scaffoldTitle: 'Activities',
        future: _fetchActivityListWithState(
            studyId: UserData.shared.curStudyId,
            participantId: UserData.shared.curParticipantId),
        builder: (context, snapshot) {
      var pbActivityList = snapshot.data as List<PbActivity>;
      return ListView.builder(
          itemCount: pbActivityList.length,
          itemBuilder: (context, index) {
            var curItem = pbActivityList[index];
            if (isPlatformIos(context)) {
              return CupertinoActivityTile(
                  curItem, () => _openActivityUI(context, curItem));
            }
            return MaterialActivityTile(
                curItem, () => _openActivityUI(context, curItem));
          });
    }, wrapInScaffold: false);
  }

  Future<Object> _fetchActivityListWithState(
      {required String studyId, required String participantId}) {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    var responseDatastoreService = getIt<ResponseDatastoreService>();

    return Future.wait([
      studyDatastoreService.getActivityList(studyId, UserData.shared.userId),
      responseDatastoreService.getActivityState(
          UserData.shared.userId, studyId, participantId)
    ]).then((responses) {
      var activityListResponse = responses[0];
      var activityStateResponse = responses[1];

      if (activityListResponse is CommonErrorResponse) {
        return activityListResponse;
      } else if (activityStateResponse is CommonErrorResponse) {
        return activityStateResponse;
      }
      var activityList =
          (activityListResponse as GetActivityListResponse).activities;
      var activityStateList =
          (activityStateResponse as GetActivityStateResponse).activities;
      List<PbActivity> pbActivityList = [];
      for (GetActivityListResponse_Activity activity in activityList) {
        var matches = activityStateList
            .where((element) => element.activityId == activity.activityId)
            .toList();
        if (matches.length == 1) {
          pbActivityList
              .add(PbActivity(activity.activityId, activity, matches.first));
        } else if (matches.isEmpty) {
          pbActivityList.add(PbActivity(
              activity.activityId,
              activity,
              GetActivityStateResponse_ActivityState.create()
                ..activityId = activity.activityId
                ..activityState = 'start'
                ..activityVersion = activity.activityVersion
                ..activityRunId = '1'
                ..activityRun =
                    (GetActivityStateResponse_ActivityState_ActivityRun.create()
                      ..total =
                          (activity.frequency.type == 'One time' ? 1 : 999)
                      ..completed = 0
                      ..missed = 0)));
        } else {
          return CommonErrorResponse(
              status: 404,
              errorDescription:
                  'Multiple states found for activity with activityId `${activity.activityId}` in this study.');
        }
      }
      if (pbActivityList.isEmpty) {
        return CommonErrorResponse(
            status: 404,
            errorDescription:
                'No valid states found for activities in this study.');
      }
      return pbActivityList;
    });
  }

  void _openActivityUI(BuildContext context, PbActivity activity) {
    var userId = UserData.shared.userId;
    var studyId = UserData.shared.curStudyId;
    var activityId = activity.activityId;
    var uniqueId = '$userId:$studyId:$activityId';
    push(
        context,
        FutureLoadingPage.build(context,
            scaffoldTitle: '',
            future: _fetchActivityStepsAndUpdateActivityState(activity),
            builder: (context, snapshot) {
          var response = snapshot.data as FetchActivityStepsResponse;
          var activityBuilder = ui_kit.getIt<ActivityBuilder>();
          return isPlatformIos(context)
              ? activityBuilder.buildActivity(response.activity.steps,
                  CupertinoActivityResponseProcessor(activity), uniqueId)
              : activityBuilder.buildActivity(response.activity.steps,
                  MaterialActivityResponseProcessor(), uniqueId);
        }, wrapInScaffold: false));
  }

  Future<Object> _fetchActivityStepsAndUpdateActivityState(
      PbActivity activity) {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    var responseDataStoreService = getIt<ResponseDatastoreService>();
    var userId = UserData.shared.userId;
    var studyId = UserData.shared.curStudyId;
    var activityId = activity.activityId;
    var activityVersion = activity.activity.activityVersion;
    return Future.wait([
      studyDatastoreService.fetchActivitySteps(
          studyId, activityId, activityVersion, userId),
      responseDataStoreService.updateActivityState(
          userId,
          studyId,
          UserData.shared.curParticipantId,
          activity.state..activityState = 'inProgress')
    ]).then((value) {
      return value[0];
    });
  }
}
