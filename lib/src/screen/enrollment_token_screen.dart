import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnrollmentTokenScreen extends StatelessWidget {
  final TextEditingController enrollmentTokenFieldController;
  final bool enrollmentTokenValidationInProgress;
  final void Function()? validateToken;

  const EnrollmentTokenScreen(
      {Key? key,
      required this.enrollmentTokenFieldController,
      required this.enrollmentTokenValidationInProgress,
      required this.validateToken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !enrollmentTokenValidationInProgress;
            },
            child: Scaffold(
                appBar: AppBar(title: Text(l10n.enrollmentTokenScreenTitle)),
                body: ListView(children: [
                  PageTextBlock(text: l10n.enrollmentTokenScreenInfoText),
                  TextFieldBlock(
                      required: true,
                      readOnly: enrollmentTokenValidationInProgress,
                      controller: enrollmentTokenFieldController,
                      keyboardType: TextInputType.text,
                      placeholder:
                          l10n.enrollmentTokenScreenTokenFieldPlaceholder,
                      textInputAction: TextInputAction.done),
                  const SizedBox(height: 96),
                  PrimaryButtonBlock(
                      title: l10n.enrollmentTokenScreenContinueToNextStepButton,
                      onPressed: enrollmentTokenValidationInProgress
                          ? null
                          : validateToken)
                ]))));
  }
}
