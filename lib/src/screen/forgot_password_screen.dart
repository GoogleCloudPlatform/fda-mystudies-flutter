import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailFieldController;
  final void Function()? forgotPassword;
  final bool forgotPasswordInProgress;

  const ForgotPasswordScreen(
      {Key? key,
      required this.emailFieldController,
      required this.forgotPassword,
      required this.forgotPasswordInProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !forgotPasswordInProgress;
            },
            child: Scaffold(
                appBar: AppBar(title: Text(l10n.forgotPasswordScreenTitle)),
                body: ListView(children: [
                  PageTextBlock(text: l10n.forgotPasswordScreenInfoText),
                  TextFieldBlock(
                      required: true,
                      readOnly: forgotPasswordInProgress,
                      controller: emailFieldController,
                      keyboardType: TextInputType.emailAddress,
                      placeholder:
                          l10n.forgotPasswordScreenEmailTextFieldPlaceholder,
                      textInputAction: TextInputAction.done),
                  const SizedBox(height: 96),
                  PrimaryButtonBlock(
                      title: l10n.forgotPasswordScreenSubmitButtonText,
                      onPressed: forgotPassword)
                ]))));
  }
}
