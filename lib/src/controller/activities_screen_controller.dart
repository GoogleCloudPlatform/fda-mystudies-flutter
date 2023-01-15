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

import '../common/pair.dart';
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
  List<ActivityBundle> activities = [];
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
    return ActivitiesScreen(
        displayShimmer: displayShimmer, activityList: activities);
  }

  void _fetchData() {
    if (!Provider.of<ConnectivityProvider>(context, listen: false)
            .isConnected ||
        !displayShimmer) {
      return;
    }

    Future.wait([_getActivityTitleFrequency(), _getActivityStatus()])
        .then((value) {
      Map<String, Pair<String, ActivityFrequency>>? idToTitleFrequencyMap =
          value[0]?.cast<String, Pair<String, ActivityFrequency>>();
      Map<String, ActivityStatus>? idToStatusMap =
          value[1]?.cast<String, ActivityStatus>();
      if (idToTitleFrequencyMap == null || idToStatusMap == null) {
        return;
      }
      final activityIdList = idToTitleFrequencyMap.keys.toList();
      List<ActivityBundle> tempList = [];
      for (var activityId in activityIdList) {
        var titleFrequency = idToTitleFrequencyMap[activityId];
        var title = titleFrequency!.first;
        var frequency = titleFrequency.second;
        var status = idToStatusMap[activityId];
        if (idToStatusMap.containsKey(activityId)) {
          tempList.add(ActivityBundle(activityId, title, status!, frequency));
        } else {
          tempList.add(ActivityBundle(
              activityId, title, ActivityStatus.yetToJoin, frequency));
        }
      }
      setState(() {
        activities = tempList;
        displayShimmer = false;
      });
    });
  }

  Future<Map<String, Pair<String, ActivityFrequency>>?>
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
      Map<String, Pair<String, ActivityFrequency>> tempMap = {};
      for (var activity in activities) {
        tempMap[activity.activityId] = Pair(activity.title,
            ActivityFrequencyExtension.valueFrom(activity.frequency.type));
      }
      return tempMap;
    });
  }

  Future<Map<String, ActivityStatus>?> _getActivityStatus() {
    final responseDatastoreService = getIt<ResponseDatastoreService>();
    return responseDatastoreService
        .getActivityState(UserData.shared.userId, UserData.shared.curStudyId,
            UserData.shared.curParticipantId)
        .then((value) {
      if (value is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, value.errorDescription);
        return null;
      }
      var activities = (value as GetActivityStateResponse).activities;
      Map<String, ActivityStatus> tempMap = {};
      for (var activity in activities) {
        tempMap[activity.activityId] =
            ActivityStatusExtension.valueFrom(activity.activityState);
      }
      return tempMap;
    });
  }
}
