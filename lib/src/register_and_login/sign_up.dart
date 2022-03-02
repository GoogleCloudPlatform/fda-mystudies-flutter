import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';
import '../common/string_extension.dart';
import '../common/widget_util.dart';
import '../cupertino_widget/cupertino_check_mark.dart';
import '../cupertino_widget/cupertino_ink_well.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _emailId = '';
  final _emailIdController = TextEditingController();
  var _password = '';
  final _passwordController = TextEditingController();
  var _confirmPassword = '';
  final _confirmPasswordController = TextEditingController();
  var _termsAndConditionsAgreed = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const emailIdPlaceholder = 'Enter email';
    const passwordPlaceholder = 'Add password';
    const confirmPasswordPlaceholder = 'Confirm password';
    var isIos = isPlatformIos(context);
    return Stack(children: [
      GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: HomeScaffold(
              child: SafeArea(
                  child: ListView(
                padding: const EdgeInsets.all(12),
                children: isIos
                    ? [
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
                        Divider(thickness: 2, color: dividerColor(context)),
                        CupertinoTextField.borderless(
                            placeholder: passwordPlaceholder,
                            controller: _passwordController,
                            maxLines: 1,
                            autocorrect: false,
                            readOnly: _isLoading,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            }),
                        Divider(thickness: 2, color: dividerColor(context)),
                        CupertinoTextField.borderless(
                            placeholder: confirmPasswordPlaceholder,
                            controller: _confirmPasswordController,
                            maxLines: 1,
                            autocorrect: false,
                            readOnly: _isLoading,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              setState(() {
                                _confirmPassword = value;
                              });
                            }),
                        Divider(thickness: 2, color: dividerColor(context)),
                        const SizedBox(height: 12),
                        Wrap(children: [
                          CupertinoCheckMark(
                              enabled: !_isLoading,
                              onTap: (value) => setState(() {
                                    _termsAndConditionsAgreed = value;
                                  })),
                          Text('I agree to ',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle),
                          CupertinoInkWell('terms ',
                              onTap: () => showWebviewModalBottomSheet(context,
                                  'https://policies.google.com/terms?hl=en-US')),
                          Text('and ',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle),
                          CupertinoInkWell('privacy policy',
                              onTap: () => showWebviewModalBottomSheet(context,
                                  'https://policies.google.com/privacy?hl=en-US'))
                        ]),
                        const SizedBox(height: 24),
                        CupertinoButton.filled(
                            child: _isLoading
                                ? const CupertinoActivityIndicator()
                                : const Text('Submit'),
                            onPressed: _signUpUser())
                      ]
                    : [],
              )),
              title: 'Sign Up',
              showDrawer: false))
    ]);
  }

  void Function()? _signUpUser() {
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
            var participantUserDatastoreService =
                getIt<ParticipantUserDatastoreService>();
            participantUserDatastoreService
                .register(_emailId, _password)
                .then((value) {
              const successfulResponse = 'User Registered successfully';
              var response = processResponse(value, successfulResponse);
              setState(() {
                _isLoading = false;
                if (response == successfulResponse) {
                  _emailId = '';
                  _password = '';
                  _confirmPassword = '';
                  _emailIdController.text = '';
                  _passwordController.text = '';
                  _confirmPasswordController.text = '';
                  _termsAndConditionsAgreed = false;
                }
              });
              if (response == successfulResponse) {
                // TODO(cg2092): Navigate to next page.
                return;
              }
              showUserMessage(context, response);
            });
          };
  }

  String? _alertMessage() {
    if (_emailId.isEmpty && _password.isEmpty && _confirmPassword.isEmpty) {
      return 'Please fill-in all the fields';
    } else if (_emailId.isEmpty) {
      return 'Please enter your Email ID';
    } else if (_password.isEmpty) {
      return 'Please enter password';
    } else if (_confirmPassword.isEmpty) {
      return 'Please confirm password';
    } else if (!_password.isAValidPassword()) {
      return 'Your password should be at least 8 characters long, and should contain a lower-case character, an upper-case character, a digit & a special character.';
    } else if (_password != _confirmPassword) {
      return 'Password & Confirm Password values do not match!';
    } else if (!_termsAndConditionsAgreed) {
      return 'Please Read & Agree to the terms & privacy policy.';
    }
  }
}
