import 'dart:developer' as developer;

import 'package:fda_mystudies/src/drawer_menu/drawer_menu.dart';
import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/response_datastore_service.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../activities_module/pb_activity.dart';
import '../user/user_data.dart';
import '../widget/fda_button.dart';

class CupertinoActivityResponseProcessor extends StatefulWidget
    implements ActivityResponseProcessor {
  final PbActivity activity;
  final ValueNotifier<List<ActivityResponse_Data_StepResult>> userResponse =
      ValueNotifier([]);

  CupertinoActivityResponseProcessor(this.activity, {Key? key})
      : super(key: key);

  @override
  State<CupertinoActivityResponseProcessor> createState() =>
      _CupertinoActivityResponseProcessorState();

  @override
  Future<void> processResponses(
      List<ActivityResponse_Data_StepResult> responses) {
    userResponse.value = responses;
    developer.log('RECEIVED RESPONSES: $responses');
    return Future.value();
  }
}

class _CupertinoActivityResponseProcessorState
    extends State<CupertinoActivityResponseProcessor> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CupertinoPageScaffold(
          navigationBar:
              const CupertinoNavigationBar(middle: SizedBox.shrink()),
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Activity Completed',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle),
                    const SizedBox(height: 12),
                    Text(
                        'Tap on \'Done\' to submit your responses. Responses cannot be modified after submission.',
                        textAlign: TextAlign.center,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .actionTextStyle),
                    const SizedBox(height: 20),
                    Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            color: CupertinoColors.activeBlue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: const Icon(Icons.check,
                            color: CupertinoColors.white, size: 50)),
                  ]))),
      Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: Container(
              decoration: BoxDecoration(
                  color: CupertinoTheme.of(context).barBackgroundColor),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FDAButton(
                            title: 'DONE',
                            isLoading: _isLoading,
                            onPressed: _processResponsesAndUpdateStates()),
                        const SizedBox(height: 20),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: CupertinoColors.activeBlue),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0))),
                            child: CupertinoButton(
                                child: const Text('CANCEL',
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue)),
                                onPressed: () => _cancelAndExit()))
                      ]))))
    ]);
  }

  void Function()? _processResponsesAndUpdateStates() {
    return _isLoading || widget.userResponse.value.isEmpty
        ? null
        : () {
            setState(() {
              _isLoading = true;
            });
            _processResponseAndUpdateStudyAndActivityStates().then((value) {
              setState(() {
                _isLoading = false;
              });
              _exitToActivitiesPage(context);
            });
          };
  }

  Future<Object> _processResponseAndUpdateStudyAndActivityStates() {
    var responseDatastoreService = getIt<ResponseDatastoreService>();
    var completed = widget.activity.state.activityRun.completed;
    return Future.wait([
      responseDatastoreService.updateActivityState(
          UserData.shared.userId,
          UserData.shared.curStudyId,
          UserData.shared.curParticipantId,
          widget.activity.state
            ..activityState = PbActivityStatus.completed.name
            ..activityRun =
                (widget.activity.state.activityRun..completed = completed + 1)),
      // TODO (cg2092): Update Study State.
      responseDatastoreService.processResponse(
          UserData.shared.userId,
          ActivityResponse.create()
            ..siteId = UserData.shared.curSiteId
            ..data = (ActivityResponse_Data.create()
              ..results.addAll(widget.userResponse.value))
            ..tokenIdentifier = UserData.shared.currentStudyTokenIdentifier
            ..applicationId = curConfig.appId
            ..participantId = UserData.shared.curParticipantId
            ..type = widget.activity.activity.type
            ..metadata = (ActivityResponse_Metadata.create()
              ..studyId = UserData.shared.curStudyId
              ..activityId = widget.activity.activityId
              ..activityRunId = widget.activity.state.activityRunId
              ..version = widget.activity.activity.activityVersion
              ..name = widget.activity.activity.title))
    ]);
  }

  void Function()? _cancelAndExit() {
    return _isLoading
        ? null
        : () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text('Save for Later'),
                    onPressed: () => _exitToActivitiesPage(context),
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Discard Results'),
                    isDestructiveAction: true,
                    onPressed: () => _exitToActivitiesPage(context),
                  )
                ],
                cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isDefaultAction: true,
                    child: const Text('Cancel')),
              ),
            );
          };
  }

  void _exitToActivitiesPage(BuildContext context) {
    Navigator.of(context)
        .popUntil(ModalRoute.withName(DrawerMenu.studyHomeRoute));
  }
}
