import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/future_loading_page.dart';
import '../common/widget_util.dart';
import '../theme/fda_color_scheme.dart';
import '../theme/fda_text_style.dart';
import '../user/user_data.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';
import '../widget/fda_text_button.dart';
import 'onboarding_process_overview.dart';
import 'sign_in.dart';

class Welcome extends StatefulWidget {
  static const welcomeRoute = '/welcome';

  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late final Future<Object>? studyInfo;

  @override
  void initState() {
    super.initState();
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    studyInfo =
        studyDatastoreService.getStudyInfo(UserData.shared.curStudyId, '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage.build(context,
        scaffoldTitle: '',
        wrapInScaffold: false,
        future: studyInfo, builder: (context, snapshot) {
      var response = snapshot.data as StudyInfoResponse;
      var infoItem = response.infos.first;
      return FDAScaffold(
          child: ListView(padding: const EdgeInsets.all(24), children: [
        const SizedBox(height: 18),
        Image(
          image: const AssetImage('assets/images/logo.png'),
          color: FDAColorScheme.googleBlue(context),
          width: 52,
          height: 47,
        ),
        const SizedBox(height: 40),
        Padding(
            padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
            child: Text(infoItem.title,
                textAlign: TextAlign.center,
                style: FDATextStyle.heading(context))),
        const SizedBox(height: 29),
        Text(infoItem.text,
            textAlign: TextAlign.center,
            style: FDATextStyle.subHeadingRegular(context)),
        const SizedBox(height: 211),
        Padding(
            padding: const EdgeInsets.fromLTRB(58, 0, 58, 0),
            child: FDAButton(
                title: AppLocalizations.of(context).tapToContinueButtonText,
                onPressed: () =>
                    push(context, const OnboardingProcessOverview()))),
        Padding(
            padding: const EdgeInsets.fromLTRB(58, 0, 58, 0),
            child: FDATextButton(
                title: AppLocalizations.of(context).skipToSignInPageButtonText,
                onPressed: () => push(context, const SignIn()))),
      ]));
    });
  }
}
