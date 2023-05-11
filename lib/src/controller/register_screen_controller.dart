import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/registration.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/widget_util.dart';
import '../extension/string_extension.dart';
import '../provider/my_account_provider.dart';
import '../route/route_name.dart';
import '../screen/register_screen.dart';
import '../user/user_data.dart';

class RegisterScreenController extends StatefulWidget {
  const RegisterScreenController({Key? key}) : super(key: key);

  @override
  State<RegisterScreenController> createState() =>
      _RegisterScreenControllerState();
}

class _RegisterScreenControllerState extends State<RegisterScreenController> {
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTnC = false;
  bool _registrationInProgress = false;

  @override
  Widget build(BuildContext context) {
    return RegisterScreen(
        emailFieldController: _emailFieldController,
        passwordFieldController: _passwordFieldController,
        confirmPasswordFieldController: _confirmPasswordController,
        registrationInProgress: _registrationInProgress,
        agreedToTnC: _agreeToTnC,
        toggledAgreement: _agreementToggled,
        register: _register);
  }

  void _agreementToggled(bool? newState) {
    setState(() {
      _agreeToTnC = newState ?? false;
    });
  }

  void _register() {
    final error = _errorMessage();
    if (error != null) {
      ErrorScenario.displayErrorMessageWithOKAction(context, error);
      return;
    }
    setState(() {
      _registrationInProgress = true;
    });
    var participantUserDatastoreService =
        getIt<ParticipantUserDatastoreService>();
    participantUserDatastoreService
        .register(_emailFieldController.text, _passwordFieldController.text)
        .then((value) {
      var successfulResponse =
          AppLocalizations.of(context).registrationSuccessfulMsg;
      var response = processResponse(value, successfulResponse);
      setState(() {
        _registrationInProgress = false;
      });
      if (response == successfulResponse) {
        Provider.of<MyAccountProvider>(context, listen: false).updateContent(
            email: _emailFieldController.text,
            tempRegId: (value as RegistrationResponse).tempRegId,
            userId: value.userId);
        UserData.shared.emailId = _emailFieldController.text;
        UserData.shared.tempRegId = value.tempRegId;
        UserData.shared.userId = value.userId;
        context.goNamed(RouteName.verificationStep);
        return;
      }
      ErrorScenario.displayErrorMessageWithOKAction(context, response);
    });
  }

  String? _errorMessage() {
    var l10n = AppLocalizations.of(context);
    if (_emailFieldController.text.isEmpty ||
        _passwordFieldController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      return l10n.registerScreenMissingRequiredFieldsErrorMessage;
    } else if (!_emailFieldController.text.isValidEmail()) {
      return l10n.registerScreenInvalidEmailErrorMessage;
    } else if (!_passwordFieldController.text.isValidPassword()) {
      return l10n.registerScreenInvalidPasswordErrorMessage;
    } else if (_passwordFieldController.text !=
        _confirmPasswordController.text) {
      return l10n.registerScreenPasswordsDontMatchErrorMessage;
    } else if (!_agreeToTnC) {
      return l10n.registerScreenTnCNotAcceptedErrorMessage;
    }
    return null;
  }
}
