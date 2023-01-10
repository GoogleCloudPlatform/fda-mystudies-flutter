import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../common/widget_util.dart';
import '../extension/string_extension.dart';
import '../screen/forgot_password_screen.dart';

class ForgotPasswordScreenController extends StatefulWidget {
  const ForgotPasswordScreenController({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreenController> createState() =>
      _ForgotPasswordScreenControllerState();
}

class _ForgotPasswordScreenControllerState
    extends State<ForgotPasswordScreenController> {
  final _emailFieldController = TextEditingController();
  bool _forgotPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScreen(
        emailFieldController: _emailFieldController,
        forgotPassword: _forgotPassword,
        forgotPasswordInProgress: _forgotPasswordInProgress);
  }

  void _forgotPassword() {
    final error = _errorMessage();
    if (error != null) {
      ErrorScenario.displayErrorMessageWithOKAction(context, error);
      return;
    }
    setState(() {
      _forgotPasswordInProgress = true;
    });
    var authenticationService = getIt<AuthenticationService>();
    authenticationService
        .resetPassword(_emailFieldController.text)
        .then((value) {
      var l10n = AppLocalizations.of(context);
      var successfulResponse =
          l10n.forgotPasswordScreenTemporaryPasswordSentMessage;
      var response = processResponse(value, successfulResponse);
      setState(() {
        _forgotPasswordInProgress = false;
      });
      if (response == successfulResponse) {
        _showPostForgotPasswordProcessDialog();
      } else {
        ErrorScenario.displayErrorMessageWithOKAction(context, response);
      }
    });
  }

  Future<void> _showPostForgotPasswordProcessDialog() {
    var l10n = AppLocalizations.of(context);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(l10n
                .forgotPasswordScreenTemporaryPasswordSentMessageDialogTitle),
            content:
                Text(l10n.forgotPasswordScreenTemporaryPasswordSentMessage),
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(l10n
                      .forgotPasswordScreenTemporaryPasswordSentMessageOkButtonText),
                  onPressed: () => context.pop()),
            ],
          );
        });
  }

  String? _errorMessage() {
    var l10n = AppLocalizations.of(context);
    if (_emailFieldController.text.isEmpty) {
      return l10n.forgotPasswordScreenMissingRequiredFieldsErrorMessage;
    } else if (!_emailFieldController.text.isValidEmail()) {
      return l10n.forgotPasswordScreenInvalidEmailErrorMessage;
    }
    return null;
  }
}
