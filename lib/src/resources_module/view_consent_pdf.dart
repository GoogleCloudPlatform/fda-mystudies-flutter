import 'dart:convert';

import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_consent_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_consent_datastore_service/get_consent_document.pbserver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';

import '../common/future_loading_page.dart';
import '../user/user_data.dart';

class ViewConsentPdf extends StatelessWidget {
  static const scaffoldTitle = 'Signed Consent Document';

  const ViewConsentPdf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ParticipantConsentDatastoreService participantConsentDatastoreService =
        getIt<ParticipantConsentDatastoreService>();
    var futureObject = participantConsentDatastoreService.getConsentDocument(
        UserData.shared.userId, UserData.shared.curStudyId);
    return FutureLoadingPage(scaffoldTitle, futureObject, (context, snapshot) {
      var consentForm =
          (snapshot.data as GetConsentDocumentResponse).consent.content;
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
