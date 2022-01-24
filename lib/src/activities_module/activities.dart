import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/future_loading_page.dart';
import '../common/widget_util.dart';
import 'cupertino_activity_response_processor.dart';
import 'cupertino_activity_tile.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return FutureLoadingPage('Study Activities',
          studyDatastoreService.getActivityList('studyId', 'userId'),
          (context, snapshot) {
        var response = snapshot.data as GetActivityListResponse;
        return ListView(
            children: response.activities
                .map((e) =>
                    CupertinoActivityTile(e, () => _openActivityUI(context, e)))
                .toList());
      }, wrapInScaffold: false);
    }
    return FutureLoadingPage('Activities',
        studyDatastoreService.getActivityList('studyId', 'userId'),
        (context, snapshot) {
      var response = snapshot.data as GetActivityListResponse;
      return ListView(
          children: response.activities.map((e) => Text(e.title)).toList());
    }, wrapInScaffold: false);
  }

  void _openActivityUI(
      BuildContext context, GetActivityListResponse_Activity activity) {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    push(
        context,
        FutureLoadingPage(
            '',
            studyDatastoreService.fetchActivitySteps(
                'studyId', activity.activityId, 'activityVersion', 'userId'),
            (context, snapshot) {
          var response = snapshot.data as FetchActivityStepsResponse;
          var activityBuilder = ui_kit.getIt<ActivityBuilder>();
          return activityBuilder.buildActivity(response.activity.steps,
              const CupertinoActivityResponseProcessor(), 'uniqueActivityId');
        }, wrapInScaffold: false));
  }
}
