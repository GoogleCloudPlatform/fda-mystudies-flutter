import 'dart:developer' as developer;

import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/page_title_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_button_block.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/response_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../provider/activities_provider.dart';
import '../route/route_name.dart';
import '../user/user_data.dart';

class MaterialActivityResponseProcessor extends StatelessWidget
    implements ActivityResponseProcessor {
  final ValueNotifier<List<ActivityResponse_Data_StepResult>> userResponse =
      ValueNotifier([]);

  MaterialActivityResponseProcessor({Key? key}) : super(key: key);

  @override
  Future<void> processResponses(
      List<ActivityResponse_Data_StepResult> responses) {
    developer.log(responses.toString());
    userResponse.value = responses;
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var activityBuilder = ui_kit.getIt<ActivityBuilder>();
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(children: [
                Image(
                  image: const AssetImage('assets/images/check.png'),
                  color: Theme.of(context).colorScheme.primary,
                  width: 60 * scaleFactor,
                  height: 60 * scaleFactor,
                ),
              ])),
          const PageTitleBlock(title: 'Activity Completed'),
          const PageTextBlock(
              text:
                  'Tap on \'Done\' to submit your responses. Responses cannot be modified after submission.',
              textAlign: TextAlign.left),
          const SizedBox(height: 92),
          PrimaryButtonBlock(
              title: 'Done',
              onPressed: () {
                activityBuilder.makeCurrentResponsesDefaultValues();
                _processAndExitToActivitiesPage(context);
              }),
          TextButtonBlock(
              title: 'Cancel',
              onPressed: () => activityBuilder.quickExitFlow(context))
        ]));
  }

  void _exitToActivitiesPage(BuildContext context) {
    context.goNamed(RouteName.activities);
  }

  void _processAndExitToActivitiesPage(BuildContext context) {
    var curActivity = Provider.of<ActivitiesProvider>(context, listen: false)
        .activityBundleList
        .firstWhere(
            (activity) => activity.activityId == UserData.shared.activityId);
    var responseDatastoreService = getIt<ResponseDatastoreService>();
    final currentTime = DateTime.now();
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final endTime =
        '${dateFormat.format(currentTime)}.${currentTime.millisecond}';
    var response = ActivityResponse()
      ..type = curActivity.type
      ..tokenIdentifier = UserData.shared.currentStudyTokenIdentifier
      ..participantId = UserData.shared.curParticipantId
      ..metadata = (ActivityResponse_Metadata()
        ..name = UserData.shared.curStudyName
        ..studyId = UserData.shared.curStudyId
        ..activityRunId = curActivity.state.activityRunId
        ..version = UserData.shared.activityVersion
        ..activityId = UserData.shared.activityId
        ..studyVersion = UserData.shared.curStudyVersion)
      ..applicationId = AppConfig.shared.currentConfig.appId
      ..data = (ActivityResponse_Data()
        ..resultType = curActivity.type
        ..startTime = userResponse.value.first.startTime
        ..endTime = endTime
        ..results.addAll(userResponse.value))
      ..siteId = UserData.shared.curSiteId;

    responseDatastoreService
        .updateLocalActivityState(
            userId: UserData.shared.userId,
            participantId: UserData.shared.curParticipantId,
            studyId: UserData.shared.curStudyId,
            activityId: UserData.shared.activityId,
            activityState: ActivityStatus.completed.toValue)
        .whenComplete(() {
      var oldActivities =
          Provider.of<ActivitiesProvider>(context, listen: false)
              .activityBundleList;
      List<ActivityBundle> updatedActivities = [];
      for (final activity in oldActivities) {
        if (activity.activityId == UserData.shared.activityId) {
          updatedActivities.add(ActivityBundle(
              activity.activityId,
              activity.type,
              activity.version,
              activity.title,
              activity.state..activityState = ActivityStatus.completed.toValue,
              activity.frequency));
        } else {
          updatedActivities.add(activity);
        }
      }
      Provider.of<ActivitiesProvider>(context, listen: false)
          .update(updatedActivities);
      _exitToActivitiesPage(context);
    });

    responseDatastoreService
        .processResponse(UserData.shared.userId, response)
        .then((value) {
      if (value is CommonErrorResponse) {
        developer.log('RESPONSE PROCESSES ERROR: ${value.errorDescription}');
        return null;
      } else {
        developer.log('RESPONSE PROCESSES: $value');
        return value;
      }
    }).then((value) {
      if (value != null) {
        return responseDatastoreService
            .updateActivityState(
                UserData.shared.userId,
                UserData.shared.curStudyId,
                UserData.shared.curParticipantId,
                curActivity.state
                  ..activityState = ActivityStatus.completed.toValue)
            .then((value) {
          if (value is CommonErrorResponse) {
            developer.log('UPDATE ACTIVITY ERROR: ${value.errorDescription}');
            return null;
          } else {
            developer.log('UPDATE ACTIVITY PROCESSES: $value');
            return value;
          }
        });
      }
      return null;
    });
  }
}
