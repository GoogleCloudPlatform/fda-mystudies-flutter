import 'package:fda_mystudies_design_system/block/agree_to_tnc_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailFieldController;
  final TextEditingController passwordFieldController;
  final TextEditingController confirmPasswordFieldController;
  final bool agreedToTnC;
  final bool registrationInProgress;
  final void Function(bool?) toggledAgreement;
  final void Function() register;

  const RegisterScreen(
      {Key? key,
      required this.emailFieldController,
      required this.passwordFieldController,
      required this.confirmPasswordFieldController,
      required this.agreedToTnC,
      required this.registrationInProgress,
      required this.toggledAgreement,
      required this.register})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !registrationInProgress;
            },
            child: Scaffold(
                appBar: AppBar(title: Text(l10n.registerScreenTitle)),
                body: ListView(children: [
                  TextFieldBlock(
                      required: true,
                      readOnly: registrationInProgress,
                      controller: emailFieldController,
                      keyboardType: TextInputType.emailAddress,
                      placeholder: l10n.registerScreenEmailTextFieldPlaceholder,
                      textInputAction: TextInputAction.next),
                  TextFieldBlock(
                      required: true,
                      readOnly: registrationInProgress,
                      controller: passwordFieldController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      placeholder:
                          l10n.registerScreenPasswordTextFieldPlaceholder,
                      helperText:
                          l10n.registerScreenPasswordConstraintsInformation,
                      textInputAction: TextInputAction.next),
                  TextFieldBlock(
                      required: true,
                      readOnly: registrationInProgress,
                      controller: confirmPasswordFieldController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      placeholder: l10n
                          .registerScreenConfirmPasswordTextFieldPlaceholder,
                      textInputAction: TextInputAction.done),
                  AgreeToTnCBlock(
                      agreedToTnC: agreedToTnC,
                      termsAndConditionsURL:
                          l10n.registerScreenTermsAndConditionsURL,
                      privacyPolicyURL: l10n.registerScreenPrivacyPolicyURL,
                      toggledAgreement:
                          registrationInProgress ? null : toggledAgreement),
                  const SizedBox(height: 96),
                  PrimaryButtonBlock(
                      title: l10n.registerScreenSubmitButtonText,
                      onPressed: registrationInProgress ? null : register)
                ]))));
  }
}
