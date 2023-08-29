import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/widget_util.dart';
import '../informed_consent_module/consent/consent_confirmed.dart';
import '../provider/eligibility_consent_provider.dart';
import '../route/route_name.dart';
import '../screen/consent_agreement_screen.dart';

class ConsentAgreementScreenController extends StatefulWidget {
  const ConsentAgreementScreenController({Key? key}) : super(key: key);

  @override
  State<ConsentAgreementScreenController> createState() =>
      _ConsentAgreementScreenControllerState();
}

class _ConsentAgreementScreenControllerState
    extends State<ConsentAgreementScreenController> {
  final _firstNameFieldController = TextEditingController();
  final _lastNameFieldController = TextEditingController();
  final _signaturePoints = <Offset>[];
  bool _enableScrolling = true;

  @override
  Widget build(BuildContext context) {
    return ConsentAgreementScreen(
        firstNameFieldController: _firstNameFieldController,
        lastNameFieldController: _lastNameFieldController,
        enableScrolling: _enableScrolling,
        signaturePoints: _signaturePoints,
        updateSignature: _updateSignature,
        clearSignature: _clearSignature,
        updateScrollingBehavior: _updateScrollingBehavior,
        continueToViewingConsentForm: _continueToViewingConsentForm,
        continueToConsentConfirmed: _continueToConsentConfirmed);
  }

  void _updateSignature(Offset offset) {
    setState(() {
      _signaturePoints.add(offset);
    });
  }

  void _clearSignature() {
    setState(() {
      _signaturePoints.clear();
    });
  }

  void _continueToViewingConsentForm() {
    final error = _errorMessage();
    if (error != null) {
      ErrorScenario.displayErrorMessageWithOKAction(context, error);
      return;
    }
    Provider.of<EligibilityConsentProvider>(context, listen: false)
        .updateUserInfo(
            firstName: _firstNameFieldController.text,
            lastName: _lastNameFieldController.text,
            signaturePoints: _signaturePoints);
    context.pushNamed(RouteName.viewSignedConsentPdf);
  }

  void _continueToConsentConfirmed() {
    final error = _errorMessage();
    if (error != null) {
      ErrorScenario.displayErrorMessageWithOKAction(context, error);
      return;
    }
    final provider =
        Provider.of<EligibilityConsentProvider>(context, listen: false);
    provider.updateUserInfo(
        firstName: _firstNameFieldController.text,
        lastName: _lastNameFieldController.text,
        signaturePoints: _signaturePoints);
    push(
        context,
        ConsentConfirmed(provider.consent.visualScreens, _signaturePoints,
            firstName: _firstNameFieldController.text,
            lastName: _lastNameFieldController.text,
            consentVersion: provider.consent.version,
            userSharingOptions: provider.selectedSharingOption));
  }

  void _updateScrollingBehavior(bool updatedScrollingState) {
    setState(() {
      _enableScrolling = updatedScrollingState;
    });
  }

  String? _errorMessage() {
    final l10n = AppLocalizations.of(context)!;
    if (_firstNameFieldController.text.isEmpty) {
      return l10n.consentAgreementScreenMissingFirstNameErrorMessage;
    } else if (_lastNameFieldController.text.isEmpty) {
      return l10n.consentAgreementScreenMissingLastNameErrorMessage;
    } else if (_signaturePoints.isEmpty) {
      return l10n.consentAgreementScreenMissingSignatureErrorMessage;
    }
    return null;
  }
}
