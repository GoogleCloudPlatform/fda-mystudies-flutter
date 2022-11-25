import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/my_account_provider.dart';

class VerificationStepScreen extends StatelessWidget {
  final TextEditingController verificationCodeFieldController;
  final bool verificationInProgress;
  final void Function()? verifyCode;
  final void Function()? resendCode;

  const VerificationStepScreen(
      {Key? key,
      required this.verificationCodeFieldController,
      required this.verificationInProgress,
      required this.verifyCode,
      required this.resendCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !verificationInProgress;
            },
            child: Scaffold(
                appBar: AppBar(title: Text(l10n.verificationStepTitle)),
                body: ListView(children: [
                  Consumer<MyAccountProvider>(
                    builder: (context, myaccount, child) => PageTextBlock(
                        text: l10n.verificationStepInfoText(myaccount.email),
                        textAlign: TextAlign.left),
                  ),
                  TextFieldBlock(
                      required: true,
                      readOnly: verificationInProgress,
                      controller: verificationCodeFieldController,
                      keyboardType: TextInputType.text,
                      placeholder:
                          l10n.verificationStepVerificationCodeFieldPlaceholder,
                      textInputAction: TextInputAction.done),
                  const SizedBox(height: 96),
                  PrimaryButtonBlock(
                      title: l10n.verificationStepVerifyCodeButtonTitle,
                      onPressed: verificationInProgress ? null : verifyCode),
                  TextButtonBlock(
                      onPressed: verificationInProgress ? null : resendCode,
                      title: l10n
                          .verificationStepResendVerificationCodeButtonTitle),
                ]))));
  }
}
