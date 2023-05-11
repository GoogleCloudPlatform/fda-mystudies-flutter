import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/verify_email.pbserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/widget_util.dart';
import '../provider/my_account_provider.dart';
import '../route/route_name.dart';
import '../screen/verification_step_screen.dart';
import '../user/user_data.dart';

class VerificationStepScreenController extends StatefulWidget {
  const VerificationStepScreenController({Key? key}) : super(key: key);

  @override
  State<VerificationStepScreenController> createState() =>
      _VerificationStepScreenControllerState();
}

class _VerificationStepScreenControllerState
    extends State<VerificationStepScreenController> {
  final _verificationCodeFieldController = TextEditingController();
  var _verificationInProgress = false;

  @override
  Widget build(BuildContext context) {
    return VerificationStepScreen(
        verificationCodeFieldController: _verificationCodeFieldController,
        verificationInProgress: _verificationInProgress,
        verifyCode: _verifyCode,
        resendCode: _resendVerificationCode);
  }

  void _verifyCode() {
    final error = _errorMessage();
    var l10n = AppLocalizations.of(context);
    if (error != null) {
      ErrorScenario.displayErrorMessageWithOKAction(context, error);
      return;
    }
    setState(() {
      _verificationInProgress = true;
    });
    final email = Provider.of<MyAccountProvider>(context, listen: false).email;
    final userId =
        Provider.of<MyAccountProvider>(context, listen: false).userId;
    var participantUserDatastore = getIt<ParticipantUserDatastoreService>();
    participantUserDatastore
        .verifyEmail(email, userId, _verificationCodeFieldController.text)
        .then((value) {
      var successfulResponse =
          l10n.verificationStepVerificationCodeSuccessfullyVerified;
      var response = processResponse(value, successfulResponse);
      setState(() {
        _verificationInProgress = false;
      });
      if (response == successfulResponse) {
        Provider.of<MyAccountProvider>(context, listen: false)
            .updateContent(tempRegId: (value as VerifyEmailResponse).tempRegId);
        UserData.shared.tempRegId = value.tempRegId;
        context.goNamed(RouteName.accountActivated);
        return;
      }
      ErrorScenario.displayErrorMessageWithOKAction(context, response);
    });
  }

  void _resendVerificationCode() {
    setState(() {
      _verificationInProgress = true;
    });
    var participantUserDatastore = getIt<ParticipantUserDatastoreService>();
    final email = Provider.of<MyAccountProvider>(context, listen: false).email;
    final userId =
        Provider.of<MyAccountProvider>(context, listen: false).userId;
    var l10n = AppLocalizations.of(context);
    participantUserDatastore.resendConfirmation(userId, email).then((value) {
      var successfulResponse =
          l10n.verificationStepVerificationCodeResentDialogText;
      var response = processResponse(value, successfulResponse);
      setState(() {
        _verificationInProgress = false;
      });
      if (response == successfulResponse) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                    l10n.verificationStepVerificationCodeResentDialogTitle),
                content:
                    Text(l10n.verificationStepVerificationCodeResentDialogText),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: Text(l10n
                        .forgotPasswordScreenTemporaryPasswordSentMessageOkButtonText),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            });
      } else {
        ErrorScenario.displayErrorMessageWithOKAction(context, response);
      }
    });
  }

  String? _errorMessage() {
    var l10n = AppLocalizations.of(context);
    if (_verificationCodeFieldController.text.isEmpty) {
      return l10n.verificationStepVerificationCodeFieldEmpty;
    }
    return null;
  }
}
