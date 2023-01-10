import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../common/string_extension.dart';
import '../common/widget_util.dart';
import '../provider/my_account_provider.dart';
import '../screen/update_password_screen.dart';

class UpdatePasswordScreenController extends StatefulWidget {
  final bool isChangingTemporaryPassword;

  const UpdatePasswordScreenController(
      {required this.isChangingTemporaryPassword, Key? key})
      : super(key: key);

  @override
  State<UpdatePasswordScreenController> createState() =>
      _UpdatePasswordScreenControllerState();
}

class _UpdatePasswordScreenControllerState
    extends State<UpdatePasswordScreenController> {
  final _currentPasswordFieldController = TextEditingController();
  final _newPasswordFieldController = TextEditingController();
  final _repeatNewPasswordFieldController = TextEditingController();
  var _passwordUpdateInProgress = false;

  @override
  Widget build(BuildContext context) {
    return UpdatePasswordScreen(
        currentPasswordFieldController: _currentPasswordFieldController,
        newPasswordFieldController: _newPasswordFieldController,
        repeatNewPasswordFieldController: _repeatNewPasswordFieldController,
        isChangingTemporaryPassword: widget.isChangingTemporaryPassword,
        passwordUpdateInProgress: _passwordUpdateInProgress,
        updatePassword: _updatePassword);
  }

  void _updatePassword() {
    final error = _errorMessage();
    final l10n = AppLocalizations.of(context);
    if (error != null) {
      ErrorScenario.displayErrorMessageWithOKAction(context, error);
      return;
    }
    setState(() {
      _passwordUpdateInProgress = true;
    });
    final userId =
        Provider.of<MyAccountProvider>(context, listen: false).userId;
    final authenticationService = getIt<AuthenticationService>();
    authenticationService
        .changePassword(userId, _currentPasswordFieldController.text,
            _newPasswordFieldController.text)
        .then((value) {
      final successfulResponse =
          l10n.updatePasswordScreenPasswordSuccessfullyChangedText;
      final response = processResponse(value, successfulResponse);
      setState(() {
        _passwordUpdateInProgress = false;
      });
      if (response == successfulResponse) {
        // TODO(cg2092): Move ahead to next screen.
      } else if (value is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, value.errorDescription);
      }
    });
  }

  String? _errorMessage() {
    final l10n = AppLocalizations.of(context);
    if (_currentPasswordFieldController.text.isEmpty &&
        _newPasswordFieldController.text.isEmpty &&
        _repeatNewPasswordFieldController.text.isEmpty) {
      return l10n.missingFieldsErrorMsg;
    } else if (_currentPasswordFieldController.text.isEmpty) {
      return widget.isChangingTemporaryPassword
          ? l10n.updatePasswordScreenTemporaryPasswordMissingText
          : l10n.updatePasswordScreenCurrentPasswordMissingText;
    } else if (_newPasswordFieldController.text.isEmpty) {
      return l10n.updatePasswordScreenNewPasswordMissingText;
    } else if (_repeatNewPasswordFieldController.text.isEmpty) {
      return l10n.updatePasswordScreenConfirmNewPasswordMissingText;
    } else if (!_newPasswordFieldController.text.isAValidPassword()) {
      return l10n.violatingPasswordConstraintsErrorMsg;
    } else if (_newPasswordFieldController.text !=
        _repeatNewPasswordFieldController.text) {
      return l10n.confirmedPasswordNotMatchingErrorMsg;
    }
    return null;
  }
}
