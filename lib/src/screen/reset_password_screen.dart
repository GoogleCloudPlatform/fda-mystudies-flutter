import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController temporaryPasswordTextFieldController;
  final TextEditingController newPasswordTextFieldController;
  final TextEditingController confirmPasswordTextFieldController;
  final void Function()? resetPassword;
  final bool resetPasswordInProgress;

  const ResetPasswordScreen(
      {Key? key,
      required this.temporaryPasswordTextFieldController,
      required this.newPasswordTextFieldController,
      required this.confirmPasswordTextFieldController,
      required this.resetPassword,
      required this.resetPasswordInProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !resetPasswordInProgress;
            },
            child: Scaffold(
                appBar: AppBar(title: Text(l10n.resetPasswordScreenTitle)),
                body: ListView(children: [
                  PageTextBlock(
                      text: l10n.resetPasswordScreenInfoText,
                      textAlign: TextAlign.left),
                  TextFieldBlock(
                      required: true,
                      readOnly: resetPasswordInProgress,
                      controller: temporaryPasswordTextFieldController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      placeholder: l10n
                          .resetPasswordScreenTemporaryPasswordTextfieldPlaceholder,
                      textInputAction: TextInputAction.next),
                  TextFieldBlock(
                      required: true,
                      readOnly: resetPasswordInProgress,
                      controller: newPasswordTextFieldController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      placeholder: l10n
                          .resetPasswordScreenNewPasswordTextfieldPlaceholder,
                      helperText: l10n
                          .resetPasswordScreenPasswordConstraintsInformation,
                      textInputAction: TextInputAction.next),
                  TextFieldBlock(
                      required: true,
                      readOnly: resetPasswordInProgress,
                      controller: confirmPasswordTextFieldController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      placeholder: l10n
                          .resetPasswordScreenConfirmNewPasswordTextfieldPlaceholder,
                      textInputAction: TextInputAction.done),
                  const SizedBox(height: 96),
                  PrimaryButtonBlock(
                      title: l10n.resetPasswordScreenResetPasswordButtonText,
                      onPressed: resetPassword)
                ]))));
  }
}
