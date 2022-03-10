import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/widgets.dart';

import '../../common/widget_util.dart';
import '../../study_home.dart';
import '../../theme/fda_text_theme.dart';
import '../../widget/fda_button.dart';
import '../../widget/fda_scaffold.dart';
import '../../widget/fda_text_button.dart';
import 'consent_pdf_generator.dart';
import 'view_consent_pdf.dart';

class ConsentConfirmed extends StatelessWidget {
  final List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
      visualScreens;
  final List<Offset> points;
  final String firstName;
  final String lastName;
  const ConsentConfirmed(this.visualScreens, this.points,
      {required this.firstName, required this.lastName, key})
      : super(key: key);

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
          onPressed: () => push(
              context,
              ViewConsentPdf(
                  ConsentPdfGenerator.generateBase64EncodingPdfString(
                      firstName,
                      lastName,
                      points,
                      198,
                      MediaQuery.of(context).size.width - 62,
                      visualScreens)))),
      const SizedBox(height: 22),
      FDAButton(
          title: 'Done',
          onPressed: () {
            pushAndRemoveUntil(context, const StudyHome());
          })
    ]));
  }
}
