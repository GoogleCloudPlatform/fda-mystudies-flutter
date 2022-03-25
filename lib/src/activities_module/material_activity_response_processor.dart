import 'dart:developer' as developer;

import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(12),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Activity Completed',
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 12),
              Text(
                  'Tap on \'Done\' to submit your responses. Responses cannot be modified after submission.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1),
              const SizedBox(height: 20),
              Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50))),
                  child:
                      const Icon(Icons.check, color: Colors.white, size: 50)),
            ])),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext buildContext) {
                              return AlertDialog(
                                content: const Text(
                                    'Your responses are stored on the app if you '
                                    '`Save for Later` (unless you sign out) so you '
                                    'can resume and complete the activity before it '
                                    'expires.'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          _exitToActivitiesPage(context),
                                      child: const Text('Save for Later')),
                                  TextButton(
                                      onPressed: () =>
                                          _exitToActivitiesPage(context),
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
                      },
                      child: const Text('CANCEL'),
                      style: Theme.of(context).textButtonTheme.style),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _exitToActivitiesPage(context),
                    child: const Text('DONE'),
                  )
                ]))));
  }

  void _exitToActivitiesPage(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }
}
