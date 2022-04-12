import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';

import '../../common/future_loading_page.dart';

class ViewConsentPdf extends StatelessWidget {
  static const scaffoldTitle = 'Signed Consent Document';
  final Future<String> base64EncodedPdf;

  const ViewConsentPdf(this.base64EncodedPdf, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage.build(context,
        scaffoldTitle: scaffoldTitle,
        future: base64EncodedPdf, builder: (context, snapshot) {
      var consentForm = snapshot.data as String;
      return SafeArea(
          child: PdfPreview(
              maxPageWidth: MediaQuery.of(context).size.width,
              build: (format) {
                return base64Decode(consentForm);
              },
              padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
              allowSharing: false,
              canDebug: false,
              dynamicLayout: false,
              allowPrinting: false,
              canChangeOrientation: false,
              canChangePageFormat: false));
    });
  }
}
