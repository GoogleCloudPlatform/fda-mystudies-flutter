import 'dart:developer' as developer;

import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_spec/authentication_service/sign_in.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../mixin/connectivity_actions.dart';
import '../extension/string_extension.dart';
import '../provider/my_account_provider.dart';
import '../route/route_name.dart';
import '../screen/sign_in_screen.dart';

class SignInScreenController extends StatefulWidget {
  const SignInScreenController({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreenController> createState() => _SignInScreenControllerState();
}

class _SignInScreenControllerState extends State<SignInScreenController>
    with ConnectivityAction {
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool _signinInProgress = false;

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
        emailFieldController: _emailFieldController,
        passwordFieldController: _passwordFieldController,
        signinInProgress: _signinInProgress,
        continueToForgotPasswordScreen: _continueToForgotPassword,
        signIn: _signIn);
  }

  void _continueToForgotPassword() {
    // context.goNamed(RouteName.forgotPassword);
  }

  void _signIn() {
    final error = _errorMessage();
    if (error != null) {
      ErrorScenario.displayErrorMessage(context, error,
          action: SnackBarAction(
              label:
                  AppLocalizations.of(context).registerScreenErrorMessageOkayed,
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar()));
      return;
    }
    setState(() {
      _signinInProgress = true;
    });
    Provider.of<MyAccountProvider>(context, listen: false)
        .updateContent(email: _emailFieldController.text);
    var authenticationService = getIt<AuthenticationService>();
    authenticationService
        .signIn(_emailFieldController.text, _passwordFieldController.text)
        .then((value) {
      if (value is SignInResponse) {
        var deeplink = Uri.dataFromString(value.location);
        if (deeplink.path.endsWith('/mystudies/signup')) {
          developer.log('SIGN UP');
        } else if (deeplink.path.endsWith('/mystudies/forgotPassword')) {
          developer.log('FORGOT PASSWORD');
        } else if (deeplink.path.endsWith('/mystudies/callback')) {
          developer.log('CALLBACK');
        } else if (deeplink.path.endsWith('/mystudies/activation')) {
          context.goNamed(RouteName.verificationStep);
        }
      } else if (value is CommonErrorResponse) {
        developer.log('ERROR: ${value.errorDescription}');
      }
    }).whenComplete(() {
      setState(() {
        _signinInProgress = false;
      });
    });
  }

  String? _errorMessage() {
    var l10n = AppLocalizations.of(context);
    if (_emailFieldController.text.isEmpty ||
        _passwordFieldController.text.isEmpty) {
      return l10n.signInScreenMissingRequiredFieldsErrorMessage;
    } else if (!_emailFieldController.text.isValidEmail()) {
      return l10n.signInScreenInvalidEmailErrorMessage;
    }
    return null;
  }
}
