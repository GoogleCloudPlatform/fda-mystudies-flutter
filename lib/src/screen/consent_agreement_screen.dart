import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/signature_block.dart';
import 'package:fda_mystudies_design_system/block/text_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsentAgreementScreen extends StatelessWidget {
  final TextEditingController firstNameFieldController;
  final TextEditingController lastNameFieldController;
  final bool enableScrolling;
  final List<Offset> signaturePoints;
  final void Function(Offset) updateSignature;
  final void Function() clearSignature;
  final void Function(bool) updateScrollingBehavior;
  final void Function()? continueToViewingConsentForm;
  final void Function()? continueToConsentConfirmed;

  const ConsentAgreementScreen(
      {Key? key,
      required this.firstNameFieldController,
      required this.lastNameFieldController,
      required this.enableScrolling,
      required this.signaturePoints,
      required this.updateSignature,
      required this.clearSignature,
      required this.updateScrollingBehavior,
      required this.continueToViewingConsentForm,
      required this.continueToConsentConfirmed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(title: Text(l10n.consentScreenTitle)),
            body: ListView(
                physics: enableScrolling
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: [
                  PageTextBlock(
                      text: l10n.consentScreenInfoText,
                      textAlign: TextAlign.left),
                  const SizedBox(height: 16),
                  PageTextBlock(
                      text: l10n.consentScreenEnterNameActionText,
                      textAlign: TextAlign.left),
                  TextFieldBlock(
                      controller: firstNameFieldController,
                      placeholder: l10n.consentScreenFirstNameFieldPlaceholder,
                      textInputAction: TextInputAction.next),
                  TextFieldBlock(
                      controller: lastNameFieldController,
                      placeholder: l10n.consentScreenLastNameFieldPlaceholder,
                      textInputAction: TextInputAction.next),
                  SignatureBlock(
                      points: signaturePoints,
                      clearCanvas: clearSignature,
                      updateParentScrollState: (shouldScroll) =>
                          updateScrollingBehavior(shouldScroll),
                      addPointToList: (point) => updateSignature(point)),
                  TextButtonBlock(
                      onPressed: continueToViewingConsentForm,
                      title: l10n.consentScreenViewConsentFormButtonTitle),
                  PrimaryButtonBlock(
                      title: l10n.consentScreenContinueButtonTitle,
                      onPressed: continueToConsentConfirmed),
                  const SizedBox(height: 32)
                ])));
  }
}
