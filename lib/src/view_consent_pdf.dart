import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';

class ViewConsentPdf extends StatelessWidget {
  final String base64EncodedPdfString;

  const ViewConsentPdf(this.base64EncodedPdfString, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const scaffoldTitle = 'Signed Consent Document';
    var pdfPreviewWidget = PdfPreview(
        maxPageWidth: MediaQuery.of(context).size.width,
        build: (format) {
          return base64Decode(base64EncodedPdfString);
        },
        padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
        allowSharing: false,
        canDebug: false,
        dynamicLayout: false,
        allowPrinting: false,
        canChangeOrientation: false,
        canChangePageFormat: false);
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
          navigationBar:
              const CupertinoNavigationBar(middle: Text(scaffoldTitle)),
          child: SafeArea(child: pdfPreviewWidget));
    }
    return Scaffold(
        appBar: AppBar(title: const Text(scaffoldTitle)),
        body: pdfPreviewWidget);
  }
}
