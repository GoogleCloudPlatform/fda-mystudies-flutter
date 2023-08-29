import 'package:fda_mystudies_design_system/block/ink_well_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailFieldController;
  final TextEditingController passwordFieldController;
  final bool signinInProgress;
  final void Function() continueToForgotPasswordScreen;
  final void Function() signIn;

  const SignInScreen(
      {Key? key,
      required this.emailFieldController,
      required this.passwordFieldController,
      required this.signinInProgress,
      required this.continueToForgotPasswordScreen,
      required this.signIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !signinInProgress;
            },
            child: Scaffold(
                appBar: AppBar(title: Text(l10n.signInScreenTitle)),
                body: ListView(children: [
                  TextFieldBlock(
                      required: true,
                      readOnly: signinInProgress,
                      controller: emailFieldController,
                      keyboardType: TextInputType.emailAddress,
                      placeholder: l10n.signInScreenEmailTextFieldPlaceholder,
                      textInputAction: TextInputAction.next),
                  TextFieldBlock(
                      required: true,
                      readOnly: signinInProgress,
                      controller: passwordFieldController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      placeholder:
                          l10n.signInScreenPasswordTextFieldPlaceholder,
                      textInputAction: TextInputAction.done),
                  InkWellBlock(
                      title: l10n.signInScreenForgotPasswordButtonText,
                      onTap: signinInProgress
                          ? null
                          : continueToForgotPasswordScreen),
                  const SizedBox(height: 96),
                  PrimaryButtonBlock(
                      title: l10n.signInScreenSignInButtonText,
                      onPressed: signinInProgress ? null : signIn)
                ]))));
  }
}
