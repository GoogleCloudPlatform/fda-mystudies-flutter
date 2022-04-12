import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../user/user_data.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
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
    return Stack(
        children: <Widget>[
              GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: HomeScaffold(
                      child: SafeArea(
                          child: ListView(
                              padding: const EdgeInsets.all(12),
                              children: isPlatformIos(context)
                                  ? [
                                      CupertinoTextField.borderless(
                                          placeholder: firstNamePlaceholder,
                                          controller: _firstNameController,
                                          maxLines: 1,
                                          autocorrect: false,
                                          readOnly: _isLoading,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (value) {
                                            setState(() {
                                              _firstName = value;
                                            });
                                          }),
                                      Divider(
                                          thickness: 2,
                                          color: dividerColor(context)),
                                      CupertinoTextField.borderless(
                                          placeholder: emailIdPlaceholder,
                                          controller: _emailIdController,
                                          maxLines: 1,
                                          autocorrect: false,
                                          readOnly: _isLoading,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (value) {
                                            setState(() {
                                              _emailId = value;
                                            });
                                          }),
                                      Divider(
                                          thickness: 2,
                                          color: dividerColor(context)),
                                      CupertinoTextField.borderless(
                                          placeholder: subjectPlaceholder,
                                          controller: _subjectController,
                                          maxLines: 1,
                                          readOnly: _isLoading,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (value) {
                                            setState(() {
                                              _subject = value;
                                            });
                                          }),
                                      Divider(
                                          thickness: 2,
                                          color: dividerColor(context)),
                                      Scrollbar(
                                          child: CupertinoTextField.borderless(
                                              placeholder: feedbackHintText,
                                              controller: _feedbackController,
                                              readOnly: _isLoading,
                                              maxLines: 10,
                                              onChanged: (value) {
                                                setState(() {
                                                  _feedback = value;
                                                });
                                              }))
                                    ]
                                  : [
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
                                                  labelText:
                                                      feedbackPlaceholder,
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
                                                child:
                                                    CircularProgressIndicator())
                                            : const Text(submitButtonLabel),
                                        style: Theme.of(context)
                                            .textButtonTheme
                                            .style)
                                  ])))))
            ] +
            (isPlatformIos(context)
                ? [
                    Positioned(
                        bottom: 0,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                            decoration: BoxDecoration(
                                color: CupertinoTheme.of(context)
                                    .barBackgroundColor),
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 40),
                                child: CupertinoButton.filled(
                                    child: _isLoading
                                        ? const CupertinoActivityIndicator()
                                        : const Text(submitButtonLabel,
                                            style: TextStyle(
                                                color: CupertinoColors.white)),
                                    onPressed: _submitFeedback()))))
                  ]
                : []));
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
