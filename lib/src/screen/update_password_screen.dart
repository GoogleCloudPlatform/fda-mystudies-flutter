import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final TextEditingController currentPasswordFieldController;
  final TextEditingController newPasswordFieldController;
  final TextEditingController repeatNewPasswordFieldController;
  final bool isChangingTemporaryPassword;
  final bool passwordUpdateInProgress;
  final void Function() updatePassword;

  const UpdatePasswordScreen(
      {Key? key,
      required this.currentPasswordFieldController,
      required this.newPasswordFieldController,
      required this.repeatNewPasswordFieldController,
      required this.isChangingTemporaryPassword,
      required this.passwordUpdateInProgress,
      required this.updatePassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !passwordUpdateInProgress;
            },
            child: Scaffold(
                appBar: AppBar(
                    title: Text(isChangingTemporaryPassword
                        ? l10n.updatePasswordScreenTemporaryPasswordTitle
                        : l10n.updatePasswordScreenCurrentPasswordTitle)),
                body: ListView(children: [
                  TextFieldBlock(
                      required: true,
                      readOnly: passwordUpdateInProgress,
                      controller: currentPasswordFieldController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      placeholder: isChangingTemporaryPassword
                          ? l10n
                              .updatePasswordScreenTemperorayPasswordFieldPlaceholder
                          : l10n
                              .updatePasswordScreenCurrentPasswordFieldPlaceholder,
                      textInputAction: TextInputAction.next),
                  TextFieldBlock(
                      required: true,
                      readOnly: passwordUpdateInProgress,
                      controller: newPasswordFieldController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      placeholder:
                          l10n.updatePasswordScreenNewPasswordFieldPlaceholder,
                      textInputAction: TextInputAction.next),
                  TextFieldBlock(
                      required: true,
                      readOnly: passwordUpdateInProgress,
                      controller: repeatNewPasswordFieldController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      placeholder: l10n
                          .updatePasswordScreenConfirmNewPasswordFieldPlaceholder,
                      textInputAction: TextInputAction.done),
                  const SizedBox(height: 96),
                  PrimaryButtonBlock(
                      title: l10n.updatePasswordScreenSubmitButtonText,
                      onPressed:
                          passwordUpdateInProgress ? null : updatePassword)
                ]))));
  }
}
