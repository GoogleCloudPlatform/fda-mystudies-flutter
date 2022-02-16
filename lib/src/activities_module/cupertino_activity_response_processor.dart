import 'dart:developer' as developer;

import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoActivityResponseProcessor extends StatelessWidget
    implements ActivityResponseProcessor {
  const CupertinoActivityResponseProcessor({Key? key}) : super(key: key);

  @override
  Future<void> processResponses(
      List<ActivityResponse_Data_StepResult> responses) {
    developer.log(responses.toString());
    return Future.value();
  }

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
                        CupertinoButton.filled(
                            child: const Text('DONE',
                                style: TextStyle(color: CupertinoColors.white)),
                            onPressed: () => _exitToActivitiesPage(context)),
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
                                onPressed: () {
                                  showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoActionSheet(
                                      actions: <CupertinoActionSheetAction>[
                                        CupertinoActionSheetAction(
                                          child: const Text('Save for Later'),
                                          onPressed: () =>
                                              _exitToActivitiesPage(context),
                                        ),
                                        CupertinoActionSheetAction(
                                          child: const Text('Discard Results'),
                                          isDestructiveAction: true,
                                          onPressed: () =>
                                              _exitToActivitiesPage(context),
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
                                }))
                      ]))))
    ]);
  }

  void _exitToActivitiesPage(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }
}
