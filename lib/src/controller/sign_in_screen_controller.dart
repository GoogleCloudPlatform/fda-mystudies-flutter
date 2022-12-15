import 'dart:developer' as developer;

import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../mixin/connectivity_actions.dart';
import '../extension/string_extension.dart';
import '../provider/my_account_provider.dart';
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
  var loginChallenge = '';

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
        emailFieldController: _emailFieldController,
        passwordFieldController: _passwordFieldController,
        signinInProgress: _signinInProgress,
        continueToForgotPasswordScreen: _continueToForgotPassword,
        signIn: _signIn);
  }

  @override
  void initState() {
    super.initState();
    dispatchOnConnectivityChanges(context, () {
      _startSignInFlow();
    });
  }

  void _startSignInFlow() {
    var authenticationService = getIt<AuthenticationService>();
    authenticationService.fireSignInURI().then((value) {
      developer.inspect(value);
      String? cookies = value.headers['set-cookie'];
      if (cookies?.isNotEmpty == true) {
        var keyValList = cookies!.split(';');
        Map<String, String> cookieMap = {};
        for (var element in keyValList) {
          var keyValPair = element.split('=');
          if (keyValPair.length == 2) {
            cookieMap[keyValPair[0]] = keyValPair[1];
          }
        }
        loginChallenge = cookieMap['mystudies_login_challenge'] ?? '';
      }
    });
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
        .signIn(_emailFieldController.text, _passwordFieldController.text,
            loginChallenge)
        .then((value) {
      developer.inspect(value);
      developer.log('${value.headers}');
      developer.log('${value.isRedirect}');
      developer.log('BODY: ${value.body}');
    }).whenComplete(() {
      setState(() {
        _signinInProgress = false;
      });
    }).ignore();
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
