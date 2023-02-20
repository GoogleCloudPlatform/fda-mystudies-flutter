import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:flutter/material.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../user/user_data.dart';

class AnonymousFeedback extends StatefulWidget {
  const AnonymousFeedback({Key? key}) : super(key: key);

  @override
  _AnonymousFeedbackState createState() => _AnonymousFeedbackState();
}

class _AnonymousFeedbackState extends State<AnonymousFeedback> {
  final _subjectTextController = TextEditingController();
  final _feedbackTextController = TextEditingController();
  String _subject = '';
  String _feedback = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Leave us your feedback';
    const subjectPlaceholder = 'Subject';
    const feedbackHintText = 'Enter your feedback here!';
    const feedbackPlaceholder = 'Feedback';
    const submitButtonLabel = 'SUBMIT';
    return Stack(children: <Widget>[
      GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: HomeScaffold(
              child: SafeArea(
                  child: ListView(
                      padding: const EdgeInsets.all(12),
                      children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                                child: Text(
                                    'We\'d love to hear from you! Please share your thoughts on how we can improve your experience of participating in health sutdies and contributing to a healthier world! Your feedback will be anonymous.',
                                    style: _bodyStyle(context)))
                          ] +
                          [
                            const SizedBox(height: 16),
                            TextField(
                                controller: _subjectTextController,
                                onChanged: (value) {
                                  setState(() {
                                    _subject = value;
                                  });
                                },
                                readOnly: _isLoading,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: subjectPlaceholder)),
                            const SizedBox(height: 16),
                            Scrollbar(
                                child: TextField(
                                    controller: _feedbackTextController,
                                    onChanged: (value) {
                                      setState(() {
                                        _feedback = value;
                                      });
                                    },
                                    readOnly: _isLoading,
                                    minLines: 1,
                                    maxLines: 10,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: feedbackPlaceholder,
                                        hintText: feedbackHintText)))
                          ])),
              title: pageTitle,
              showDrawer: false,
              bottomNavigationBar: BottomAppBar(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: _submitFeedback(),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator())
                                    : const Text(submitButtonLabel),
                                style: Theme.of(context).textButtonTheme.style)
                          ])))))
    ]);
  }

  void Function()? _submitFeedback() {
    return _isLoading
        ? null
        : () {
            var alertMessage = _alertMessage();
            if (alertMessage != null) {
              showUserMessage(context, alertMessage);
              return;
            }
            setState(() {
              _isLoading = true;
            });
            var participantUserDatastore =
                getIt<ParticipantUserDatastoreService>();
            participantUserDatastore
                .feedback(UserData.shared.userId, _subject, _feedback)
                .then((value) {
              const successfulResponse =
                  'Thank you for providing feedback. Your gesture is appreciated.';
              var response = processResponse(value, successfulResponse);
              setState(() {
                _isLoading = false;
                if (response == successfulResponse) {
                  _subject = '';
                  _feedback = '';
                  _subjectTextController.text = '';
                  _feedbackTextController.text = '';
                }
              });
              showUserMessage(context, response);
            });
          };
  }

  String? _alertMessage() {
    if (_subject.isEmpty) {
      return 'Subject should not be empty';
    } else if (_feedback.isEmpty) {
      return 'Feedback should not be empty';
    }
    return null;
  }

  TextStyle? _bodyStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.apply(fontSizeFactor: 1.2);
  }
}
