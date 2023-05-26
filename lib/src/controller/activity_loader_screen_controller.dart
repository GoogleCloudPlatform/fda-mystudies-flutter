import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/response_datastore_service.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mixin/connectivity_actions.dart';
import '../provider/activities_provider.dart';
import '../provider/activity_step_provider.dart';
import '../provider/connectivity_provider.dart';
import '../screen/activity_loader_screen.dart';
import '../user/user_data.dart';

class ActivityLoaderScreenController extends StatefulWidget {
  const ActivityLoaderScreenController({Key? key}) : super(key: key);

  @override
  State<ActivityLoaderScreenController> createState() =>
      _ActivityLoaderScreenControllerState();
}

class _ActivityLoaderScreenControllerState
    extends State<ActivityLoaderScreenController> with ConnectivityAction {
  var _activityLoadingInProgress = true;

  @override
  void initState() {
    super.initState();
    dispatchOnConnectivityChanges(context, () {
      if (_activityLoadingInProgress) {
        _fetchActivityStepsAndUpdateActivity();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActivityLoaderScreen(
        activityLoadingInProgress: _activityLoadingInProgress);
  }

  void _fetchActivityStepsAndUpdateActivity() {
    if (!Provider.of<ConnectivityProvider>(context, listen: false)
            .isConnected ||
        !_activityLoadingInProgress) {
      return;
    }
    _fetchActivitySteps().then((value) {
      if (value != null) {
        setState(() {
          _activityLoadingInProgress = false;
        });
        _updateActivityState();
      }
    });
  }

  Future<List<ActivityStep>?> _fetchActivitySteps() {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    return studyDatastoreService
        .fetchActivitySteps(
            UserData.shared.curStudyId,
            UserData.shared.activityId,
            UserData.shared.activityVersion,
            UserData.shared.userId)
        .then((value) {
      if (value is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, value.errorDescription);
        return null;
      } else if (value is FetchActivityStepsResponse) {
        Provider.of<ActivityStepProvider>(context, listen: false)
            .update(value.activity.steps);
        return value.activity.steps;
      }
      return null;
    });
  }

  Future<CommonResponse?> _updateActivityState() {
    final activities = Provider.of<ActivitiesProvider>(context, listen: false)
        .activityBundleList;
    var activityState = activities
        .firstWhere(
            (activity) => activity.activityId == UserData.shared.activityId)
        .state;
    var responseDataStoreService = getIt<ResponseDatastoreService>();
    return responseDataStoreService
        .updateActivityState(
            UserData.shared.userId,
            UserData.shared.curStudyId,
            UserData.shared.curParticipantId,
            activityState..activityState = ActivityStatus.inProgress.toValue)
        .then((value) {
      if (value is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, value.errorDescription);
        return null;
      } else if (value is CommonResponse) {
        return value;
      }
      return null;
    });
  }
}
