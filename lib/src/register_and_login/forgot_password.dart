import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../theme/fda_text_theme.dart';
import '../widget/fda_button.dart';
import '../widget/fda_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _emailId = '';
  final _emailIdController = TextEditingController();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: HomeScaffold(
            child: SafeArea(
                child: ListView(padding: const EdgeInsets.all(12), children: [
              const SizedBox(height: 18),
              Text(
                  'Please enter your registered email to receivce password help.',
                  textAlign: TextAlign.center,
                  style: FDATextTheme.bodyTextStyle(context)),
              const SizedBox(height: 18),
              FDATextField(
                placeholder: 'Email ID',
                textEditingController: _emailIdController,
                onChanged: (value) {
                  setState(() {
                    _emailId = value;
                  });
                },
                maxLines: 1,
                autocorrect: false,
                readOnly: _isLoading,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 18),
              FDAButton(
                  isLoading: _isLoading,
                  title: 'Submit',
                  onPressed: _forgotPassword())
            ])),
            title: 'Password help',
            showDrawer: false));
  }

  void Function()? _forgotPassword() {
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
            var authenticationService = getIt<AuthenticationService>();
            authenticationService.resetPassword(_emailId).then((value) {
              const successfulResponse =
                  'We have sent a temporary password to your registered email. Please sign in with the temporary password and then change your password.';
              var response = processResponse(value, successfulResponse);
              setState(() {
                _isLoading = false;
                if (response == successfulResponse) {
                  _emailId = '';
                  _emailIdController.text = '';
                }
              });
              if (response == successfulResponse) {
                Navigator.of(context).pop();
              }
              showUserMessage(context, response);
            });
          };
  }

  String? _alertMessage() {
    if (_emailId.isEmpty) {
      return 'Please fill in your registered Email ID';
    }
  }
}
