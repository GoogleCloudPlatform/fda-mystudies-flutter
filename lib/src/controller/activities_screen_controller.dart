import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/response_datastore_service.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pbserver.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mixin/connectivity_actions.dart';
import '../provider/activities_provider.dart';
import '../provider/connectivity_provider.dart';
import '../screen/activities_screen.dart';
import '../user/user_data.dart';

class ActivitiesScreenController extends StatefulWidget {
  const ActivitiesScreenController({Key? key}) : super(key: key);

  @override
  State<ActivitiesScreenController> createState() =>
      _ActivitiesScreenControllerState();
}

class _ActivitiesScreenControllerState extends State<ActivitiesScreenController>
    with ConnectivityAction {
  var displayShimmer = true;

  @override
  void initState() {
    super.initState();
    dispatchOnConnectivityChanges(context, () {
      if (displayShimmer) {
        _fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActivitiesScreen(displayShimmer: displayShimmer);
  }

  void _fetchData() {
    if (!Provider.of<ConnectivityProvider>(context, listen: false)
            .isConnected ||
        !displayShimmer) {
      return;
    }

    Future.wait([_getActivityTitleFrequency(), _getActivityStatus()])
        .then((value) {
      Map<String, _ActivityTitleVersionFrequency>? idToTitleFrequencyMap =
          value[0]?.cast<String, _ActivityTitleVersionFrequency>();
      Map<String, GetActivityStateResponse_ActivityState>? idToStateMap =
          value[1]?.cast<String, GetActivityStateResponse_ActivityState>();
      if (idToTitleFrequencyMap == null || idToStateMap == null) {
        return;
      }
      final activityIdList = idToTitleFrequencyMap.keys.toList();
      List<ActivityBundle> tempList = [];
      for (var activityId in activityIdList) {
        var activityTitleVersionFrequency = idToTitleFrequencyMap[activityId];
        var title = activityTitleVersionFrequency?.title ?? '';
        var type = activityTitleVersionFrequency?.type ?? 'questionnaire';
        var version = activityTitleVersionFrequency?.version ?? '';
        var frequency = activityTitleVersionFrequency?.frequency ??
            ActivityFrequency.customSchedule;
        var status = idToStateMap[activityId];
        if (idToStateMap.containsKey(activityId)) {
          tempList.add(ActivityBundle(
              activityId, type, version, title, status!, frequency));
        } else {
          tempList.add(ActivityBundle(
              activityId,
              type,
              version,
              title,
              GetActivityStateResponse_ActivityState.create()
                ..activityId = activityId
                ..activityState = ActivityStatus.yetToJoin.toValue
                ..activityVersion = version
                ..activityRunId = '1'
                ..activityRun =
                    (GetActivityStateResponse_ActivityState_ActivityRun.create()
                      ..total =
                          (frequency == ActivityFrequency.oneTime ? 1 : 999)
                      ..completed = 0
                      ..missed = 0),
              frequency));
        }
      }
      Provider.of<ActivitiesProvider>(context, listen: false).update(tempList);
      setState(() {
        displayShimmer = false;
      });
    });
  }

  Future<Map<String, _ActivityTitleVersionFrequency>?>
      _getActivityTitleFrequency() {
    final studyDatastoreService = getIt<StudyDatastoreService>();
    return studyDatastoreService
        .getActivityList(UserData.shared.curStudyId, UserData.shared.userId)
        .then((value) {
      if (value is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, value.errorDescription);
        return null;
      }
      var activities = (value as GetActivityListResponse).activities;
      if (activities.isEmpty) {
        ErrorScenario.displayErrorMessageWithOKAction(context,
            'No activities found for this Study! Please check back later.');
        return null;
      }
      Map<String, _ActivityTitleVersionFrequency> tempMap = {};
      for (var activity in activities) {
        tempMap[activity.activityId] = _ActivityTitleVersionFrequency(
            activity.title,
            activity.type,
            activity.activityVersion,
            ActivityFrequencyExtension.valueFrom(activity.frequency.type));
      }
      return tempMap;
    });
  }

  Future<Map<String, GetActivityStateResponse_ActivityState>?>
      _getActivityStatus() {
    final responseDatastoreService = getIt<ResponseDatastoreService>();
    return responseDatastoreService
        .getActivityState(UserData.shared.userId, UserData.shared.curStudyId,
            UserData.shared.curParticipantId)
        .then((value) async {
      if (value is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, value.errorDescription);
        return null;
      }
      var activities = (value as GetActivityStateResponse).activities;
      Map<String, GetActivityStateResponse_ActivityState> tempMap = {};
      for (var activity in activities) {
        var updatedActivityState =
            await responseDatastoreService.getLocalActivityState(
                userId: UserData.shared.userId,
                studyId: UserData.shared.curStudyId,
                participantId: UserData.shared.curParticipantId,
                activityId: activity.activityId,
                date: DateTime.now());
        tempMap[activity.activityId] = activity
          ..activityState = (updatedActivityState.isEmpty
              ? activity.activityState
              : updatedActivityState);
      }
      return tempMap;
    });
  }
}

class _ActivityTitleVersionFrequency {
  final String title;
  final String type;
  final String version;
  final ActivityFrequency frequency;

  _ActivityTitleVersionFrequency(
      this.title, this.type, this.version, this.frequency);
}
