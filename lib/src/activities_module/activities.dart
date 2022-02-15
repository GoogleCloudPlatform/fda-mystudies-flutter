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
    return FutureLoadingPage(
        'Activities',
        _fetchActivityListWithState(
            userId: 'userId',
            studyId: 'studyId',
            authToken: 'authToken',
            participantId: 'participantId'), (context, snapshot) {
      var pbActivityList = snapshot.data as List<PbActivity>;
      return ListView(
          children: pbActivityList.map((e) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoActivityTile(
              e, () => _openActivityUI(context, e.activity));
        }
        return MaterialActivityTile(
            e, () => _openActivityUI(context, e.activity));
      }).toList());
    }, wrapInScaffold: false);
  }

  Future<Object> _fetchActivityListWithState(
      {required String userId,
      required String studyId,
      required String authToken,
      required String participantId}) {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    var responseDatastoreService = getIt<ResponseDatastoreService>();

    return Future.wait([
      studyDatastoreService.getActivityList(studyId, userId),
      responseDatastoreService.getActivityState(
          userId, authToken, studyId, participantId)
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
        // There should be one and only one element in the activityStateList with activity id element.activityId.
        if (matches.length == 1) {
          pbActivityList
              .add(PbActivity(activity.activityId, activity, matches.first));
        } else if (matches.isEmpty) {
          return CommonErrorResponse(
              status: 404,
              errorDescription:
                  'No valid state found for activity with activityId `${activity.activityId}` in this study.');
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

  void _openActivityUI(
      BuildContext context, GetActivityListResponse_Activity activity) {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    var platformIsIos = (Theme.of(context).platform == TargetPlatform.iOS);
    var userId = 'userId';
    var studyId = 'studyId';
    var activityId = activity.activityId;
    var activityVersion = activity.activityVersion;
    var uniqueId = '$userId:$studyId:$activityId';
    push(
        context,
        FutureLoadingPage(
            '',
            studyDatastoreService.fetchActivitySteps(
                studyId, activity.activityId, activityVersion, userId),
            (context, snapshot) {
          var response = snapshot.data as FetchActivityStepsResponse;
          var activityBuilder = ui_kit.getIt<ActivityBuilder>();
          return platformIsIos
              ? activityBuilder.buildActivity(response.activity.steps,
                  const CupertinoActivityResponseProcessor(), uniqueId)
              : activityBuilder.buildActivity(response.activity.steps,
                  const MaterialActivityResponseProcessor(), uniqueId);
        }, wrapInScaffold: false));
  }
}
