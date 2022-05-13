import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../theme/fda_text_theme.dart';
import '../user/user_data.dart';
import '../widget/fda_button.dart';
import '../widget/fda_text_button.dart';
import '../widget/fda_text_field.dart';
import 'registration_complete.dart';

class VerificationStep extends StatefulWidget {
  const VerificationStep({Key? key}) : super(key: key);

  @override
  State<VerificationStep> createState() => _VerificationStepState();
}

class _VerificationStepState extends State<VerificationStep> {
  final _verificationCodeController = TextEditingController();
  var _verificationCode = '';
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: HomeScaffold(
            title: 'Verification step',
            showDrawer: false,
            child: SafeArea(
                child: ListView(padding: const EdgeInsets.all(12), children: [
              const SizedBox(height: 22),
              Text(
                  'An email has been sent to ${UserData.shared.emailId.isEmpty ? 'your registered email id' : UserData.shared.emailId}. Please type in the verification code received in the email to complete account setup.',
                  textAlign: TextAlign.center,
                  style: FDATextTheme.bodyTextStyle(context)),
              const SizedBox(height: 22),
              FDATextField(
                placeholder: 'Verification code',
                textEditingController: _verificationCodeController,
                maxLines: 1,
                autocorrect: false,
                readOnly: _isLoading,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    _verificationCode = value;
                  });
                },
              ),
              const SizedBox(height: 22),
              FDAButton(
                  title: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _verifyRegistration()),
              const SizedBox(height: 22),
              FDATextButton(
                  title: 'Resend verification code',
                  isLoading: _isLoading,
                  onPressed: _resendVerificationCode())
            ]))));
  }

  void Function()? _verifyRegistration() {
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
                .verifyEmail(UserData.shared.emailId, UserData.shared.userId,
                    _verificationCode)
                .then((value) {
              const successfulResponse = 'Email ID verified successfully!';
              var response = processResponse(value, successfulResponse);
              setState(() {
                _isLoading = false;
                if (response == successfulResponse) {
                  _verificationCode = '';
                  _verificationCodeController.text = '';
                }
              });
              if (response == successfulResponse) {
                pushAndRemoveUntil(context, const RegistrationComplete());
                return;
              }
              showUserMessage(context, response);
            });
          };
  }

  void Function()? _resendVerificationCode() {
    return _isLoading
        ? null
        : () {
            setState(() {
              _isLoading = true;
            });
            var participantUserDatastore =
                getIt<ParticipantUserDatastoreService>();
            participantUserDatastore
                .resendConfirmation(
                    UserData.shared.userId, UserData.shared.emailId)
                .then((value) {
              const successfulResponse =
                  'A verification code has been sent to your registered email';
              var response = processResponse(value, successfulResponse);
              setState(() {
                _isLoading = false;
                if (response == successfulResponse) {
                  _verificationCode = '';
                  _verificationCodeController.text = '';
                }
              });
              showUserMessage(context, response);
            });
          };
  }

  String? _alertMessage() {
    if (_verificationCode.isEmpty) {
      return 'Please enter valid verification code';
    }
  }
}
