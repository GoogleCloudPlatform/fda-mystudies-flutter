import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:flutter/material.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../user/user_data.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String _firstName = '';
  String _emailId = '';
  String _subject = '';
  String _feedback = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Contact us';
    const firstNamePlaceholder = 'First Name';
    const emailIdPlaceholder = 'Email address';
    const subjectPlaceholder = 'Subject';
    const feedbackPlaceholder = 'Feedback';
    const feedbackHintText = 'Enter your feedback here!';
    const submitButtonLabel = 'SUBMIT';
    return Stack(children: <Widget>[
      GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: HomeScaffold(
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
                                style: Theme.of(context).textButtonTheme.style,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator())
                                    : const Text(submitButtonLabel))
                          ]))),
              child: SafeArea(
                  child: ListView(padding: const EdgeInsets.all(12), children: [
                TextField(
                    controller: _firstNameController,
                    autocorrect: false,
                    onChanged: (value) {
                      setState(() {
                        _firstName = value;
                      });
                    },
                    readOnly: _isLoading,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: firstNamePlaceholder)),
                const SizedBox(height: 16),
                TextField(
                    controller: _emailIdController,
                    autocorrect: false,
                    onChanged: (value) {
                      setState(() {
                        _emailId = value;
                      });
                    },
                    readOnly: _isLoading,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: emailIdPlaceholder)),
                const SizedBox(height: 16),
                TextField(
                    controller: _subjectController,
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
                        controller: _feedbackController,
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
              ]))))
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
                .contactUs(UserData.shared.userId, _subject, _feedback,
                    _emailId, _firstName)
                .then((value) {
              const successfulResponse =
                  'Thank you for contacting us. We will get back to you as soon as possible';
              var response = processResponse(value, successfulResponse);
              setState(() {
                _isLoading = false;
                if (response == successfulResponse) {
                  _firstName = '';
                  _subject = '';
                  _feedback = '';
                  _firstNameController.text = '';
                  _subjectController.text = '';
                  _feedbackController.text = '';
                }
              });
              showUserMessage(context, response);
            });
          };
  }

  String? _alertMessage() {
    if (_firstName.isEmpty) {
      return 'First Name should not be empty';
    } else if (_emailId.isEmpty) {
      return 'Email address should not empty';
    } else if (_subject.isEmpty) {
      return 'Subject should not be empty';
    } else if (_feedback.isEmpty) {
      return 'Feedback should not be empty';
    }
    return null;
  }
}
