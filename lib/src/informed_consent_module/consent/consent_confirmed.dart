import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_consent_datastore_service.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/enroll_in_study.pbserver.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/widgets.dart';

import '../../common/widget_util.dart';
import '../../study_home.dart';
import '../../study_module/study_tile/pb_user_study_status.dart';
import '../../theme/fda_text_theme.dart';
import '../../user/user_data.dart';
import '../../widget/fda_button.dart';
import '../../widget/fda_scaffold.dart';
import '../../widget/fda_text_button.dart';
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
    return FDAScaffold(
        child: ListView(padding: const EdgeInsets.all(16), children: [
      const SizedBox(height: 84),
      Text('Consent confirmed',
          style: FDATextTheme.headerTextStyle(context),
          textAlign: TextAlign.center),
      const SizedBox(height: 22),
      Text('You can now start using the app to participate in the study.',
          style: FDATextTheme.bodyTextStyle(context),
          textAlign: TextAlign.center),
      const SizedBox(height: 22),
      FDATextButton(
          title: 'View eConsent PDF',
          onPressed: () =>
              push(context, ViewConsentPdf(_generateBase64PdfString(context)))),
      const SizedBox(height: 22),
      FDAButton(
          title: 'Done', isLoading: _isLoading, onPressed: _enrollUser(context))
    ]));
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
                  pushAndRemoveUntil(context, const StudyHome());
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
