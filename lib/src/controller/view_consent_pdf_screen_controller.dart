import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../informed_consent_module/consent/consent_pdf_generator.dart';
import '../provider/eligibility_consent_provider.dart';
import '../screen/view_consent_pdf_screen.dart';

class ViewConsentPdfScreenController extends StatefulWidget {
  const ViewConsentPdfScreenController({Key? key}) : super(key: key);

  @override
  State<ViewConsentPdfScreenController> createState() =>
      _ViewConsentPdfScreenControllerState();
}

class _ViewConsentPdfScreenControllerState
    extends State<ViewConsentPdfScreenController> {
  var _base64EncodedPdf = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<EligibilityConsentProvider>(
        builder: (context, provider, child) {
      if (_base64EncodedPdf.isNotEmpty) {
        return ViewConsentPdfScreen(
            base64EncodedPdf: _base64EncodedPdf, displayShimmer: false);
      }
      _generateBase64PdfString(
          firstName: provider.firstName,
          lastName: provider.lastName,
          signaturePoints: provider.signaturePoints,
          visualScreens: provider.consent.visualScreens);
      return const ViewConsentPdfScreen(
          base64EncodedPdf: '', displayShimmer: true);
    });
  }

  void _generateBase64PdfString(
      {required String firstName,
      required String lastName,
      required List<Offset> signaturePoints,
      required List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
          visualScreens}) {
    ConsentPdfGenerator.generateBase64EncodingPdfString(
            firstName,
            lastName,
            signaturePoints,
            198,
            MediaQuery.of(context).size.width - 62,
            visualScreens)
        .then((value) => setState(() {
              _base64EncodedPdf = value;
            }));
  }
}
