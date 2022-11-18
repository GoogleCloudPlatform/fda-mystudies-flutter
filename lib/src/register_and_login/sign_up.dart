import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/registration.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/home_scaffold.dart';
import '../common/string_extension.dart';
import '../common/widget_util.dart';
import '../theme/fda_text_style.dart';
import '../user/user_data.dart';
import '../widget/fda_button.dart';
import '../widget/fda_check_box.dart';
import '../widget/fda_ink_well.dart';
import '../widget/fda_text_field.dart';
import 'verification_step.dart';

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
    var emailIdPlaceholder =
        AppLocalizations.of(context).signUpEmailPlaceholder;
    var passwordPlaceholder =
        AppLocalizations.of(context).signUpPasswordPlaceholder;
    var confirmPasswordPlaceholder =
        AppLocalizations.of(context).signUpConfirmPasswordPlaceholder;
    return Stack(children: [
      GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: HomeScaffold(
              child: SafeArea(
                  child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  FDATextField(
                      placeholder: emailIdPlaceholder,
                      textEditingController: _emailIdController,
                      maxLines: 1,
                      autocorrect: false,
                      readOnly: _isLoading,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          _emailId = value;
                        });
                      }),
                  const SizedBox(height: 24),
                  FDATextField(
                      placeholder: passwordPlaceholder,
                      textEditingController: _passwordController,
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
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                          AppLocalizations.of(context)
                              .signUpPasswordConstraintsInfoText,
                          style: FDATextStyle.information(context))),
                  const SizedBox(height: 24),
                  FDATextField(
                      placeholder: confirmPasswordPlaceholder,
                      textEditingController: _confirmPasswordController,
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
                  const SizedBox(height: 24),
                  Wrap(children: [
                    FDACheckBox(
                        enabled: !_isLoading,
                        value: _termsAndConditionsAgreed,
                        onTap: (value) => setState(() {
                              _termsAndConditionsAgreed = value;
                            })),
                    Text('  ${AppLocalizations.of(context).iAgreeTo} ',
                        style: FDATextStyle.inlineText(context)),
                    FDAInkWell(
                        '${AppLocalizations.of(context).termsAndConditions} ',
                        onTap: () => showWebviewModalBottomSheet(context,
                            url: 'https://policies.google.com/terms?hl=en-US')),
                    Text('${AppLocalizations.of(context).and} ',
                        style: FDATextStyle.inlineText(context)),
                    FDAInkWell(AppLocalizations.of(context).privacyPolicy,
                        onTap: () => showWebviewModalBottomSheet(context,
                            url:
                                'https://policies.google.com/privacy?hl=en-US'))
                  ]),
                  const SizedBox(height: 24),
                  Padding(
                      padding: const EdgeInsets.all(55),
                      child: FDAButton(
                          title:
                              AppLocalizations.of(context).signUpSubmitButton,
                          isLoading: _isLoading,
                          onPressed: _signUpUser()))
                ],
              )),
              title: AppLocalizations.of(context).signUpPageTitle,
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
              var successfulResponse =
                  AppLocalizations.of(context).registrationSuccessfulMsg;
              var response = processResponse(value, successfulResponse);
              setState(() {
                _isLoading = false;
                if (response == successfulResponse) {
                  _password = '';
                  _confirmPassword = '';
                  _emailIdController.text = '';
                  _passwordController.text = '';
                  _confirmPasswordController.text = '';
                  _termsAndConditionsAgreed = false;
                }
              });
              if (response == successfulResponse) {
                UserData.shared.tempRegId =
                    (value as RegistrationResponse).tempRegId;
                UserData.shared.userId = value.userId;
                pushAndRemoveUntil(context, const VerificationStep());
                return;
              }
              showUserMessage(context, response);
            });
          };
  }

  String? _alertMessage() {
    if (_emailId.isEmpty && _password.isEmpty && _confirmPassword.isEmpty) {
      return AppLocalizations.of(context).missingFieldsErrorMsg;
    } else if (_emailId.isEmpty) {
      return AppLocalizations.of(context).missingEmailIdErrorMsg;
    } else if (_password.isEmpty) {
      return AppLocalizations.of(context).missingPasswordErrorMsg;
    } else if (_confirmPassword.isEmpty) {
      return AppLocalizations.of(context).missingConfirmPasswordErrorMsg;
    } else if (!_password.isAValidPassword()) {
      return AppLocalizations.of(context).violatingPasswordConstraintsErrorMsg;
    } else if (_password != _confirmPassword) {
      return AppLocalizations.of(context).confirmedPasswordNotMatchingErrorMsg;
    } else if (!_termsAndConditionsAgreed) {
      return AppLocalizations.of(context).termsAndConditionsNotAgreedToErrorMsg;
    }
    return null;
  }
}
