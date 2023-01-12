import 'dart:convert';

import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printing/printing.dart';

class ViewConsentPdfScreen extends StatelessWidget {
  final String base64EncodedPdf;
  final bool displayShimmer;

  const ViewConsentPdfScreen(
      {Key? key, required this.base64EncodedPdf, required this.displayShimmer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(l10n.signedConsentDocumentTitle)),
        body: _renderPDF(context));
  }

  Widget _renderPDF(BuildContext context) {
    if (displayShimmer) {
      return ListView(children: const [
        PageTextBlock(
            text: '', shimmerHeightMultiplier: 3, displayShimmer: true),
        PageTextBlock(
            text: '', shimmerHeightMultiplier: 8, displayShimmer: true),
        PageTextBlock(
            text: '', shimmerHeightMultiplier: 9, displayShimmer: true)
      ]);
    }
    return PdfPreview(
        maxPageWidth: MediaQuery.of(context).size.width,
        build: (format) {
          return base64Decode(base64EncodedPdf);
        },
        padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
        allowSharing: false,
        canDebug: false,
        dynamicLayout: false,
        allowPrinting: false,
        canChangeOrientation: false,
        canChangePageFormat: false);
  }
}
