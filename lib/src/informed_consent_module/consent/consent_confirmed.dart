import 'package:fda_mystudies_design_system/block/ink_well_block.dart';
import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/page_title_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_consent_datastore_service.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/enroll_in_study.pbserver.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../common/widget_util.dart';
import '../../route/route_name.dart';
import '../../study_module/study_tile/pb_user_study_status.dart';
import '../../user/user_data.dart';
import 'consent_pdf_generator.dart';
import 'view_consent_pdf.dart';

class ConsentConfirmed extends StatefulWidget {
  final List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
      visualScreens;
  final List<Offset> points;
  final String firstName;
  final String lastName;
  final String consentVersion;
  final String userSharingOptions;
  const ConsentConfirmed(this.visualScreens, this.points,
      {required this.firstName,
      required this.lastName,
      required this.consentVersion,
      required this.userSharingOptions,
      key})
      : super(key: key);

  @override
  State<ConsentConfirmed> createState() => _ConsentConfirmedState();
}

class _ConsentConfirmedState extends State<ConsentConfirmed> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
        onWillPop: () async => !_isLoading,
        child: Scaffold(
            appBar: _isLoading ? null : AppBar(),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        child: Row(children: [
                          Image(
                            image: const AssetImage('assets/images/check.png'),
                            color: Theme.of(context).colorScheme.primary,
                            width: 60 * scaleFactor,
                            height: 60 * scaleFactor,
                          ),
                        ])),
                    PageTitleBlock(title: l10n.consentConfirmedScreenTitle),
                    PageTextBlock(
                        text: l10n.consentConfirmedScreenSubtitle,
                        textAlign: TextAlign.left),
                    InkWellBlock(
                        title:
                            l10n.consentConfirmedScreenViewConsentPdfButtonText,
                        onTap: () => push(context,
                            ViewConsentPdf(_generateBase64PdfString(context)))),
                    const SizedBox(height: 92),
                    PrimaryButtonBlock(
                        title: l10n.consentConfirmedScreenNextScreenButtonText,
                        onPressed: _enrollUser(context))
                  ])));
  }

  void Function()? _enrollUser(BuildContext context) {
    return _isLoading
        ? null
        : () {
            setState(() {
              _isLoading = true;
            });
            var participantEnrollDatastoreService =
                getIt<ParticipantEnrollDatastoreService>();
            var participantConsentDatastoreService =
                getIt<ParticipantConsentDatastoreService>();
            participantEnrollDatastoreService
                .enrollInStudy(
                    UserData.shared.userId,
                    UserData.shared.currentStudyTokenIdentifier,
                    UserData.shared.curStudyId)
                .then((value) {
              if (value is EnrollInStudyResponse) {
                UserData.shared.curSiteId = value.siteId;
                UserData.shared.currentStudyTokenIdentifier = value.hashedToken;
                UserData.shared.curParticipantId = value.participantId;
                Future.wait([
                  _generateBase64PdfString(context).then((base64Pdf) =>
                      participantConsentDatastoreService
                          .updateEligibilityAndConsentStatus(
                              UserData.shared.userId,
                              UserData.shared.curStudyId,
                              UserData.shared.curSiteId,
                              widget.consentVersion,
                              base64Pdf,
                              widget.userSharingOptions)),
                  participantEnrollDatastoreService.updateStudyState(
                      UserData.shared.userId, UserData.shared.curStudyId,
                      studyStatus: PbUserStudyStatus.enrolled.stringValue,
                      siteId: UserData.shared.curSiteId,
                      participantId: UserData.shared.curParticipantId)
                ]).then((value) {
                  setState(() {
                    _isLoading = false;
                  });
                  context.goNamed(RouteName.studyHome);
                });
              }
            });
          };
  }

  Future<String> _generateBase64PdfString(BuildContext context) {
    return ConsentPdfGenerator.generateBase64EncodingPdfString(
        widget.firstName,
        widget.lastName,
        widget.points,
        198,
        MediaQuery.of(context).size.width - 62,
        widget.visualScreens);
  }
}
