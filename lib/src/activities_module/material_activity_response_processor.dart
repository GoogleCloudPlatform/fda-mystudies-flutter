import 'dart:developer' as developer;

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

import '../../main.dart';
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
                  'Tap on\'Done\' to submit your responses. Responses cannot be modified after submission.',
              textAlign: TextAlign.left),
          const SizedBox(height: 92),
          PrimaryButtonBlock(
              title: 'Done',
              onPressed: () => _processAndExitToActivitiesPage(context)),
          TextButtonBlock(
              title: 'Cancel', onPressed: () => _cancelActivity(context))
        ]));
  }

  void _cancelActivity(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            content: const Text('Your responses are stored on the app if you '
                '`Save for Later` (unless you sign out) so you '
                'can resume and complete the activity before it '
                'expires.'),
            actions: [
              TextButton(
                  onPressed: () => _exitToActivitiesPage(context),
                  child: const Text('Save for Later')),
              TextButton(
                  onPressed: () => _exitToActivitiesPage(context),
                  child: const Text('Discard Results',
                      style: TextStyle(color: Colors.red))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
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
      ..applicationId = curConfig.appId
      ..data = (ActivityResponse_Data()
        ..resultType = curActivity.type
        ..startTime = userResponse.value.first.startTime
        ..endTime = endTime
        ..results.addAll(userResponse.value))
      ..siteId = UserData.shared.curSiteId;

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
    }).then((value) {
      if (value != null) {
        _exitToActivitiesPage(context);
      }
    });
  }
}
